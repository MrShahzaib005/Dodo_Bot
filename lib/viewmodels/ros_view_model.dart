import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:rosbridge/rosbridge.dart';

class RosViewModel extends ChangeNotifier {
  // 1. Connection Variables
  late Ros _ros;
  bool _isConnected = false;
  
  // 2. Movement Variables
  late Topic _cmdVel;

  // 3. Map Variables
  late Topic _mapTopic;
  ui.Image? _mapImage; 
  
  // Map Metadata
  double _mapResolution = 0.05;
  int _mapWidth = 0;
  int _mapHeight = 0;
  Pose _mapOrigin = Pose(
    position: Point(x: 0, y: 0, z: 0), 
    orientation: Quaternion(x:0, y:0, z:0, w:1)
  );

  // Getters for UI
  bool get isConnected => _isConnected;
  ui.Image? get mapImage => _mapImage;
  double get mapResolution => _mapResolution;
  Pose get mapOrigin => _mapOrigin;

  // Constructor
  RosViewModel() {
    _initRos();
  }

  void _initRos() {
    // API of the Server Computer
    _ros = Ros(url: 'ws://100.86.161.103:9090'); 

    _ros.statusStream.listen((status) {
      _isConnected = (status == Status.connected);
      if (kDebugMode) {
        print("ROS STATUS: $status");
      }
      notifyListeners();
    });

    _initTopics();
    connect();
  }

  void _initTopics() {
    // A. Movement Topic
    _cmdVel = Topic(
      ros: _ros,
      name: '/cmd_vel',
      type: 'geometry_msgs/Twist',
      reconnectOnClose: true,
      queueLength: 10,
      queueSize: 10,
    );

    // B. Map Topic
    _mapTopic = Topic(
      ros: _ros,
      name: '/map',
      type: 'nav_msgs/OccupancyGrid',
      reconnectOnClose: true,
      queueLength: 1, 
    );

    // Listen for Map Data
    _mapTopic.subscribe((msg) async {
      await _processMapMessage(msg);
    });
  }

  void connect() {
    try {
      _ros.connect();
    } catch (e) {
      if (kDebugMode) print("Connection Error: $e");
    }
  }

  // --- MOVEMENT FUNCTIONS ---
  
  void move(double linearX, double angularZ) {
    if (!_isConnected) return;

    final msg = {
      'linear': {'x': linearX, 'y': 0.0, 'z': 0.0},
      'angular': {'x': 0.0, 'y': 0.0, 'z': angularZ}
    };

    _cmdVel.publish(msg);
  }

  void stop() {
    move(0.0, 0.0);
  }

  // --- MAP PROCESSING FUNCTIONS ---

  Future<void> _processMapMessage(Map<String, dynamic> msg) async {
    try {
      // 1. Extract Metadata
      final info = msg['info'];
      _mapWidth = info['width'];
      _mapHeight = info['height'];
      _mapResolution = info['resolution'];
      
      final originPos = info['origin']['position'];
      final originOr = info['origin']['orientation'];
      
      _mapOrigin = Pose(
        position: Point(x: (originPos['x'] as num).toDouble(), y: (originPos['y'] as num).toDouble(), z: (originPos['z'] as num).toDouble()),
        orientation: Quaternion(
          x: (originOr['x'] as num).toDouble(), 
          y: (originOr['y'] as num).toDouble(), 
          z: (originOr['z'] as num).toDouble(), 
          w: (originOr['w'] as num).toDouble()
        )
      );

      // 2. Extract Data
      final List<dynamic> data = msg['data'];

      // 3. Convert to Pixels (RGBA)
      final Uint8List pixels = Uint8List(_mapWidth * _mapHeight * 4);

      for (int i = 0; i < data.length; i++) {
        int val = data[i];
        int r = 0, g = 0, b = 0, a = 255;

        if (val == -1) {
          // Unknown = Transparent Grey
          r = 200; g = 200; b = 200; a = 50; 
        } else if (val == 0) {
          // Free = White
          r = 255; g = 255; b = 255; a = 255;
        } else if (val == 100) {
          // Wall = Black
          r = 0; g = 0; b = 0; a = 255;
        } else {
          // Probabilistic
          int gray = 255 - ((val / 100.0) * 255).round();
          r = gray; g = gray; b = gray;
        }

        int offset = i * 4;
        pixels[offset] = r;
        pixels[offset + 1] = g;
        pixels[offset + 2] = b;
        pixels[offset + 3] = a;
      }

      // 4. Create Image
      final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(pixels);
      final ui.ImageDescriptor descriptor = ui.ImageDescriptor.raw(
        buffer,
        width: _mapWidth,
        height: _mapHeight,
        pixelFormat: ui.PixelFormat.rgba8888,
      );
      final ui.Codec codec = await descriptor.instantiateCodec();
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      _mapImage = frameInfo.image;
      notifyListeners();
      
    } catch (e) {
      print("Error processing map: $e");
    }
  }
}

// Simple Data Classes
class Pose {
  final Point position;
  final Quaternion orientation;
  Pose({required this.position, required this.orientation});
}

class Point { 
  final double x, y, z; 
  Point({required this.x, required this.y, required this.z}); 
}

class Quaternion { 
  final double x, y, z, w; 
  Quaternion({required this.x, required this.y, required this.z, required this.w}); 
}