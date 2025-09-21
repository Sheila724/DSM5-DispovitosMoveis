import 'package:flutter/material.dart';

/// Widget reutilizável para campos de entrada de texto
/// 
/// Este componente é Stateless pois não gerencia estado próprio,
/// apenas exibe o campo de texto configurado pelos parâmetros
class CustomTextFormField extends StatelessWidget {
  /// Controlador do campo de texto
  final TextEditingController controller;
  
  /// Rótulo do campo
  final String label;
  
  /// Texto de dica quando o campo está vazio
  final String hint;
  
  /// Ícone a ser exibido no campo
  final IconData? icon;
  
  /// Tipo de teclado a ser exibido
  final TextInputType? keyboardType;
  
  /// Função de validação do campo
  final String? Function(String?)? validator;
  
  /// Define se o campo é obrigatório
  final bool isRequired;
  
  /// Número máximo de linhas do campo
  final int maxLines;

  /// Construtor do widget de campo de texto personalizado
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.icon,
    this.keyboardType,
    this.validator,
    this.isRequired = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator ?? (isRequired ? _defaultValidator : null),
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
  
  /// Validador padrão para campos obrigatórios
  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '$label é obrigatório';
    }
    return null;
  }
}