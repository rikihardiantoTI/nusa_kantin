import 'package:flutter/material.dart';

class MenuVisual extends StatelessWidget {
  final String name;
  final String category;
  final double height;

  const MenuVisual({
    super.key,
    required this.name,
    required this.category,
    this.height = 112,
  });

  IconData get _icon {
    final value = name.toLowerCase();
    if (value.contains('kopi')) {
      return Icons.coffee;
    }
    if (value.contains('teh')) {
      return Icons.local_cafe;
    }
    if (value.contains('pisang')) {
      return Icons.bakery_dining;
    }
    if (value.contains('mie') || value.contains('soto')) {
      return Icons.ramen_dining;
    }
    if (value.contains('ayam')) {
      return Icons.lunch_dining;
    }
    if (category == 'Minuman') {
      return Icons.local_drink;
    }
    return Icons.fastfood;
  }

  Color get _background {
    if (category == 'Minuman') return const Color(0xFFDCECE6);
    if (category == 'Camilan') return const Color(0xFFFFEDC7);
    return const Color(0xFFFFDFC6);
  }

  Color get _foreground {
    if (category == 'Minuman') return const Color(0xFF367A68);
    if (category == 'Camilan') return const Color(0xFFC47A28);
    return const Color(0xFFBD5A38);
  }

  String? get _imageUrl {
    final value = name.toLowerCase();
    if (value.contains('ayam')) {
      return 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=700&q=82';
    }
    if (value.contains('mie')) {
      return 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=700&q=82';
    }
    if (value.contains('soto')) {
      return 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=700&q=82';
    }
    if (value.contains('kopi')) {
      return 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?auto=format&fit=crop&w=700&q=82';
    }
    if (value.contains('teh')) {
      return 'https://images.unsplash.com/photo-1499638673689-79a0b5115d3?auto=format&fit=crop&w=700&q=82';
    }
    if (value.contains('pisang')) {
      return 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?auto=format&fit=crop&w=700&q=82';
    }
    if (value.contains('cireng')) {
      return 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=700&q=82';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_imageUrl != null)
            Positioned.fill(
              child: Image.network(
                _imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallbackIllustration(),
              ),
            ),
          if (_imageUrl != null)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.10),
                    ],
                  ),
                ),
              ),
            ),
          if (_imageUrl == null) _fallbackIllustration(),
        ],
      ),
    );
  }

  Widget _fallbackIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          right: -18,
          bottom: -24,
          child: Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: _foreground.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            shape: BoxShape.circle,
          ),
          child: Icon(_icon, size: 36, color: _foreground),
        ),
      ],
    );
  }
}
