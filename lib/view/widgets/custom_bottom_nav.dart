import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 111,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // Uma sombra preta bem suave (12% de opacidade)
            blurRadius: 25.0,       // O quanto a sombra fica esfumaçada
            offset: Offset(0, -3), // Move a sombra 3 pixels para CIMA
          ),
        ],
        color: Color(0xFFF9A86B), 
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SafeArea( 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildNavItem(Icons.home, 'Início', 0),
            _buildNavItem(Icons.pets, 'Pets', 1),
            _buildCenterButton(2),
            _buildNavItem(Icons.person_outline, 'Perfil', 3),
            _buildNavItem(Icons.settings, 'configurações', 4),
          ],
        ),
      ),
    );
  }

  // Método atualizado usando IconButton
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => onTap(index),
          icon: Icon(icon),
          color: Colors.white,
          iconSize: 40,
          // Removemos os espaçamentos padrão do IconButton para não quebrar o layout
          padding: EdgeInsets.zero, 
          constraints: const BoxConstraints(), 
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, 
          ),
        ),
      ],
    );
  }

  // Botão central atualizado usando IconButton
  Widget _buildCenterButton(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            color: Color(0xFF4285F4),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => onTap(index),
            icon: const Icon(Icons.add),
            color: Colors.white,
            iconSize: 30,
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Anunciar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}