/// Valores fixos usados nos formulários de pet.
///
/// Antes ficavam hardcoded dentro do State da view (ex: `especies`).
/// Isolar aqui facilita reutilizar as mesmas listas em outra tela
/// (filtro de busca, edição de pet) sem duplicar ou dessincronizar.
class PetConstantes {
  PetConstantes._();

  static const List<String> especies = [
    'Cachorro',
    'Gato',
    'Pássaro',
    'Outros',
  ];

  static const List<String> generos = ['Macho', 'Fêmea'];

  static const List<String> portes = ['Pequeno', 'Médio', 'Grande'];
}