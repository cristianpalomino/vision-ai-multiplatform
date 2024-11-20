import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/image_model.dart';
import '../services/image_service.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isLoading = true;
  List<ImageModel> _images = [];
  String? _error;
  ImageService? _imageService;

  @override
  void initState() {
    super.initState();
    _imageService = ImageService();
    _loadImages();
  }

  @override
  void dispose() {
    _imageService?.dispose();
    super.dispose();
  }

  Future<void> _loadImages() async {
    if (!mounted) return;

    try {
      setState(() => _isLoading = true);
      final images = await _imageService?.getImages();
      if (!mounted) return;

      setState(() {
        _images = images ?? [];
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  String _getStatusText(ImageStatus status) {
    switch (status) {
      case ImageStatus.PENDING:
        return 'Pending';
      case ImageStatus.PROCESSING:
        return 'Processing';
      case ImageStatus.COMPLETED:
        return 'Completed';
      case ImageStatus.FAILED:
        return 'Failed';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(ImageStatus status) {
    switch (status) {
      case ImageStatus.PENDING:
        return Colors.orange;
      case ImageStatus.PROCESSING:
        return Colors.blue;
      case ImageStatus.COMPLETED:
        return Colors.green;
      case ImageStatus.FAILED:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Upload from Gallery'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement gallery upload
            },
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Upload from URL'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement URL upload
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadImages,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: $_error',
                          style: const TextStyle(color: Colors.red),
                        ),
                        ElevatedButton(
                          onPressed: _loadImages,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _buildImageGrid(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadOptions,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildImageGrid() {
    if (_images.isEmpty) {
      return const Center(
        child: Text('No images yet. Upload some!'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        final image = _images[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Image.network(
                image.storage.url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image),
                  );
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusText(image.status),
                        style: TextStyle(
                          color: _getStatusColor(image.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${image.uuid.substring(0, 3)}...${image.uuid.substring(image.uuid.length - 3)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
