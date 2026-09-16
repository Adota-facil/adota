import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/view/widgets/appBar_Widget.dart';

class EditarPetView extends StatefulWidget {
  final PetModel pet;

  const EditarPetView({super.key, required this.pet});

  @override
  State<EditarPetView> createState() => _EditarPetViewState();
}

class _EditarPetViewState extends State<EditarPetView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late TextEditingController _idadeController;
  late TextEditingController _porteController;
  late TextEditingController _racaController;
  late TextEditingController _localizacaoController;
  late TextEditingController _descricaoController;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.pet.nome);
    _idadeController = TextEditingController(text: widget.pet.idade);
    _porteController = TextEditingController(text: widget.pet.porte);
    _racaController = TextEditingController(text: widget.pet.raca);
    _localizacaoController = TextEditingController(
      text: widget.pet.localizacao,
    );
    _descricaoController = TextEditingController(text: widget.pet.descricao);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _porteController.dispose();
    _racaController.dispose();
    _localizacaoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _atualizarPet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      await FirebaseFirestore.instance
          .collection('animais')
          .doc(widget.pet.id)
          .update({
            'nome': _nomeController.text.trim(),
            'idade': _idadeController.text.trim(),
            'porte': _porteController.text.trim(),
            'raca': _racaController.text.trim(),
            'localizacao': _localizacaoController.text.trim(),
            'descricao': _descricaoController.text.trim(),
          });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informações atualizadas com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarWidget(
        leadingName: 'Editar Pet',
        mostrarBotaoVoltar: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Atualize os dados do pet',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Modifique as informações abaixo e salve as alterações.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  _buildTextField(
                    controller: _nomeController,
                    label: 'Nome do Pet',
                    icon: Icons.pets,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Por favor, informe o nome'
                        : null,
                  ),
                  const SizedBox(height: 18),

                  _buildTextField(
                    controller: _idadeController,
                    label: 'Idade',
                    icon: Icons.cake_outlined,
                  ),
                  const SizedBox(height: 18),

                  _buildTextField(
                    controller: _porteController,
                    label: 'Porte (Ex: Pequeno, Médio, Grande)',
                    icon: Icons.straighten,
                  ),
                  const SizedBox(height: 18),

                  _buildTextField(
                    controller: _racaController,
                    label: 'Raça',
                    icon: Icons.category_outlined,
                  ),
                  const SizedBox(height: 18),

                  _buildTextField(
                    controller: _localizacaoController,
                    label: 'Localização',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 18),

                  _buildTextField(
                    controller: _descricaoController,
                    label: 'Descrição',
                    icon: Icons.description_outlined,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _salvando ? null : _atualizarPet,
                      child: _salvando
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Salvar Alterações',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: maxLines == 1
            ? Icon(icon, color: const Color(0xFF1976D2), size: 20)
            : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 1.5),
        ),
      ),
    );
  }
}
