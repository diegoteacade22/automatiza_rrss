import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

// Models
class Post {
  final String id;
  final String title;
  final String content;
  final List<String> platforms;
  final DateTime scheduledDate;
  final PostStatus status;
  final String? imageUrl;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.platforms,
    required this.scheduledDate,
    required this.status,
    this.imageUrl,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      platforms: List<String>.from(json['platforms'] ?? []),
      scheduledDate: DateTime.parse(json['scheduledDate'] ?? DateTime.now().toIso8601String()),
      status: PostStatus.values.firstWhere(
        (e) => e.toString() == 'PostStatus.${json['status'] ?? 'draft'}',
        orElse: () => PostStatus.draft,
      ),
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'platforms': platforms,
      'scheduledDate': scheduledDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Post copyWith({
    String? id,
    String? title,
    String? content,
    List<String>? platforms,
    DateTime? scheduledDate,
    PostStatus? status,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      platforms: platforms ?? this.platforms,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum PostStatus {
  draft,
  scheduled,
  published,
  error,
}

extension PostStatusExtension on PostStatus {
  Color get color {
    switch (this) {
      case PostStatus.draft:
        return Colors.grey;
      case PostStatus.scheduled:
        return Colors.blue;
      case PostStatus.published:
        return Colors.green;
      case PostStatus.error:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case PostStatus.draft:
        return Icons.edit;
      case PostStatus.scheduled:
        return Icons.schedule;
      case PostStatus.published:
        return Icons.check_circle;
      case PostStatus.error:
        return Icons.error;
    }
  }

  String get displayName {
    switch (this) {
      case PostStatus.draft:
        return 'Borrador';
      case PostStatus.scheduled:
        return 'Programado';
      case PostStatus.published:
        return 'Publicado';
      case PostStatus.error:
        return 'Error';
    }
  }
}

// Services
class PostService with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PostService() {
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(seconds: 1));
      
      // Datos de ejemplo
      _posts = [
        Post(
          id: '1',
          title: 'Lanzamiento de Producto',
          content: '¡Estamos emocionados de anunciar nuestro nuevo producto! #Innovación #Tecnología',
          platforms: ['Instagram', 'Facebook', 'Twitter'],
          scheduledDate: DateTime.now().add(const Duration(days: 2)),
          status: PostStatus.scheduled,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Post(
          id: '2',
          title: 'Consejos de Negocio',
          content: '5 consejos para mejorar tu estrategia digital en 2025',
          platforms: ['LinkedIn', 'Twitter'],
          scheduledDate: DateTime.now().subtract(const Duration(days: 1)),
          status: PostStatus.published,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Post(
          id: '3',
          title: 'Borrador de Ideas',
          content: 'Ideas para el próximo artículo sobre inteligencia artificial',
          platforms: ['LinkedIn'],
          scheduledDate: DateTime.now().add(const Duration(days: 5)),
          status: PostStatus.draft,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];
    } catch (e) {
      _error = 'Error al cargar publicaciones: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPost(Post post) async {
    try {
      _posts.add(post);
      notifyListeners();
    } catch (e) {
      _error = 'Error al crear publicación: $e';
      notifyListeners();
    }
  }

  Future<void> updatePost(Post updatedPost) async {
    try {
      final index = _posts.indexWhere((post) => post.id == updatedPost.id);
      if (index != -1) {
        _posts[index] = updatedPost;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error al actualizar publicación: $e';
      notifyListeners();
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      _posts.removeWhere((post) => post.id == postId);
      notifyListeners();
    } catch (e) {
      _error = 'Error al eliminar publicación: $e';
      notifyListeners();
    }
  }

  Future<void> publishPost(String postId) async {
    try {
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(status: PostStatus.published);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error al publicar: $e';
      notifyListeners();
    }
  }

  Future<void> schedulePost(String postId, DateTime scheduleDate) async {
    try {
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(
          status: PostStatus.scheduled,
          scheduledDate: scheduleDate,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error al programar publicación: $e';
      notifyListeners();
    }
  }

  void refresh() {
    _loadPosts();
  }
}

// Main App
void main() {
  initializeDateFormatting('es_ES', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostService(),
      child: MaterialApp(
        title: 'Social Scheduler',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.blueAccent,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        routes: {
          '/create-post': (context) => const CreatePostScreen(),
          '/post-manager': (context) => const PostManagerScreen(),
        },
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostService>(context, listen: false).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Scheduler'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => postService.refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.pushNamed(context, '/post-manager'),
          ),
        ],
      ),
      body: SafeArea(
        child: postService.isLoading
            ? const Center(child: CircularProgressIndicator())
            : postService.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          postService.error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => postService.refresh(),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : postService.posts.isEmpty
                    ? const Center(
                        child: Text('No hay publicaciones programadas'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: postService.posts.length,
                        itemBuilder: (context, index) {
                          final post = postService.posts[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: post.status.color,
                                child: Icon(post.status.icon, color: Colors.white),
                              ),
                              title: Text(post.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Programado: ${_formatDate(post.scheduledDate)}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                  Text(
                                    'Plataformas: ${post.platforms.join(', ')}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                              trailing: Chip(
                                label: Text(post.status.displayName),
                                backgroundColor: post.status.color.withValues(alpha: 0.2),
                                labelStyle: TextStyle(color: post.status.color),
                              ),
                            ),
                          );
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-post'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Create Post Screen
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  final List<String> _selectedPlatforms = [];
  DateTime _scheduledDate = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;

  final List<Map<String, dynamic>> _platforms = [
    {'name': 'Instagram', 'icon': Icons.camera_alt, 'color': Colors.pink},
    {'name': 'Facebook', 'icon': Icons.facebook, 'color': Colors.blue},
    {'name': 'Twitter', 'icon': Icons.chat_bubble, 'color': Colors.lightBlue},
    {'name': 'LinkedIn', 'icon': Icons.work, 'color': Colors.indigo},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _scheduledDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (!mounted || picked == null) return;

    final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_scheduledDate),
    );

    if (!mounted || time == null) return;

    setState(() {
          _scheduledDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
    });
  }

  Future<void> _saveAsDraft() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        content: _contentController.text,
        platforms: _selectedPlatforms,
        scheduledDate: _scheduledDate,
        status: PostStatus.draft,
        createdAt: DateTime.now(),
      );

      if (mounted) {
        Provider.of<PostService>(context, listen: false).createPost(post);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Borrador guardado exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _schedulePost() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        content: _contentController.text,
        platforms: _selectedPlatforms,
        scheduledDate: _scheduledDate,
        status: PostStatus.scheduled,
        createdAt: DateTime.now(),
      );

      if (mounted) {
        Provider.of<PostService>(context, listen: false).createPost(post);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicación programada exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al programar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;
    if (_selectedPlatforms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona al menos una plataforma')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                    hintText: 'Ingresa el título de tu publicación',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Contenido',
                    border: OutlineInputBorder(),
                    hintText: 'Escribe el contenido de tu publicación',
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa contenido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Plataformas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _platforms.map((platform) {
                    final isSelected = _selectedPlatforms.contains(platform['name']);
                    return FilterChip(
                      label: Text(platform['name'] as String),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedPlatforms.add(platform['name'] as String);
                          } else {
                            _selectedPlatforms.remove(platform['name'] as String);
                          }
                        });
                      },
                      backgroundColor: isSelected 
                          ? (platform['color'] as Color).withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? (platform['color'] as Color) : Colors.grey,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Fecha de Publicación',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(_formatDate(_scheduledDate)),
                    trailing: const Icon(Icons.edit),
                    onTap: _selectDate,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveAsDraft,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Guardar Borrador'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _schedulePost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Programar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Post Manager Screen
class PostManagerScreen extends StatefulWidget {
  const PostManagerScreen({super.key});

  @override
  State<PostManagerScreen> createState() => _PostManagerScreenState();
}

class _PostManagerScreenState extends State<PostManagerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostService>(context, listen: false).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Publicaciones'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: postService.isLoading
            ? const Center(child: CircularProgressIndicator())
            : postService.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          postService.error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => postService.refresh(),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : postService.posts.isEmpty
                    ? const Center(
                        child: Text('No hay publicaciones'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: postService.posts.length,
                        itemBuilder: (context, index) {
                          final post = postService.posts[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: post.status.color,
                                child: Icon(post.status.icon, color: Colors.white),
                              ),
                              title: Text(post.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Programado: ${_formatDate(post.scheduledDate)}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                  Text(
                                    'Plataformas: ${post.platforms.join(', ')}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Chip(
                                    label: Text(post.status.displayName),
                                    backgroundColor: post.status.color.withValues(alpha: 0.2),
                                    labelStyle: TextStyle(color: post.status.color),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Eliminar Publicación'),
                                          content: const Text('¿Estás seguro de que quieres eliminar esta publicación?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                      
                                      if (confirmed == true) {
                                        postService.deletePost(post.id);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}