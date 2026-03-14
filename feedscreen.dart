// lib/screens/feed_screen.dart
import 'package:flutter/material.dart';

// Modelo de Post (temporário até implementarmos o banco de dados)
class Post {
  final int id;
  final String username;
  final String fullName;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool userLiked;

  Post({
    required this.id,
    required this.username,
    required this.fullName,
    required this.content,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.userLiked = false,
  });

  // Dados mockados para teste
  static List<Post> mockPosts() {
    return [
      Post(
        id: 1,
        username: 'admin',
        fullName: 'Administrador',
        content: 'Bem-vindo ao Papa Goiaba! Esta é a primeira postagem de teste. 🎉',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        likesCount: 42,
        commentsCount: 7,
        userLiked: false,
      ),
      Post(
        id: 2,
        username: 'maria_silva',
        fullName: 'Maria Silva',
        content: 'Acabei de descobrir esse app incrível! Muito bom ver uma rede social com esse visual único. 🌿',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 23,
        commentsCount: 3,
        userLiked: true,
      ),
      Post(
        id: 3,
        username: 'joao_dev',
        fullName: 'João Desenvolvedor',
        content: 'Testando o feed do Papa Goiaba. Em breve teremos muitas funcionalidades legais por aqui! 🚀',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        likesCount: 15,
        commentsCount: 2,
        userLiked: false,
      ),
    ];
  }
}

// Widget de Post individual
class PostWidget extends StatefulWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const PostWidget({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isLiked = false;
  int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.userLiked;
    _likesCount = widget.post.likesCount;
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likesCount--;
      } else {
        _likesCount++;
      }
      _isLiked = !_isLiked;
    });
    
    // Chamar callback se existir
    if (widget.onLike != null) {
      widget.onLike!();
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'agora';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF2A3A2A),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho do post
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5A2B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Informações do usuário
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.post.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '@${widget.post.username}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatTimeAgo(widget.post.createdAt),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Menu de opções (só aparece para posts do próprio usuário)
                if (widget.post.username == 'admin') // Temporário
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white70),
                    color: const Color(0xFF4A2E1A),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text(
                          'Editar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          // Implementar edição depois
                        },
                      ),
                      PopupMenuItem(
                        child: const Text(
                          'Excluir',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          // Implementar exclusão depois
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          
          // Conteúdo do post
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              widget.post.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          
          // Imagem do post (opcional - placeholder)
          Container(
            height: 200,
            width: double.infinity,
            color: const Color(0xFF4A2E1A),
            child: Center(
              child: Icon(
                Icons.image,
                size: 50,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          
          // Estatísticas (likes e comentários)
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  size: 18,
                  color: _isLiked ? Colors.red : Colors.white54,
                ),
                const SizedBox(width: 5),
                Text(
                  _likesCount.toString(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.comment,
                  size: 18,
                  color: Colors.white54,
                ),
                const SizedBox(width: 5),
                Text(
                  widget.post.commentsCount.toString(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Linha divisória
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          
          // Botões de ação
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Botão Curtir
                _buildActionButton(
                  icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                  label: 'Curtir',
                  color: _isLiked ? Colors.red : Colors.white70,
                  onTap: _toggleLike,
                ),
                
                // Botão Comentar
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  label: 'Comentar',
                  color: Colors.white70,
                  onTap: () {
                    if (widget.onComment != null) {
                      widget.onComment!();
                    }
                  },
                ),
                
                // Botão Compartilhar
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Compartilhar',
                  color: Colors.white70,
                  onTap: () {
                    if (widget.onShare != null) {
                      widget.onShare!();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Tela de Feed principal
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    setState(() => _isLoading = true);
    
    // Simular carregamento da rede
    await Future.delayed(const Duration(seconds: 1));
    
    // Carregar posts mockados
    setState(() {
      _posts = Post.mockPosts();
      _isLoading = false;
    });
  }

  Future<void> _refreshFeed() async {
    await _loadFeed();
  }

  void _goToCreatePost() {
    Navigator.pushNamed(context, '/create_post');
  }

  void _goToProfile() {
    Navigator.pushNamed(context, '/profile');
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A3A2A),
        title: const Text(
          'Sair',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Deseja realmente sair?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3B1A),
      
      // AppBar personalizada (estilo Instagram)
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A2E1A),
        elevation: 0,
        title: const Text(
          'Papa Goiaba',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          // Botão Nova Postagem
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: Colors.white),
            onPressed: _goToCreatePost,
          ),
          
          // Botão Perfil
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: _goToProfile,
          ),
          
          // Botão Sair
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      
      // Corpo da tela
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        color: const Color(0xFF8B5A2B),
        backgroundColor: const Color(0xFF4A2E1A),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF8B5A2B),
                ),
              )
            : _posts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.post_add,
                          size: 80,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Nenhuma postagem ainda',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Clique no + para criar a primeira!',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      return PostWidget(
                        post: _posts[index],
                        onLike: () {
                          // Implementar like no banco depois
                          print('Curtiu post ${_posts[index].id}');
                        },
                        onComment: () {
                          // Navegar para comentários
                          Navigator.pushNamed(
                            context,
                            '/comments',
                            arguments: _posts[index].id,
                          );
                        },
                        onShare: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Compartilhar (em breve)'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }
}