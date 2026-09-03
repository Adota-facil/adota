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

  static const List<String> estados = [
    'Acre',
    'Alagoas',
    'Amapá',
    'Amazonas',
    'Bahia',
    'Ceará',
    'Distrito Federal',
    'Espírito Santo',
    'Goiás',
    'Maranhão',
    'Mato Grosso',
    'Mato Grosso do Sul',
    'Minas Gerais',
    'Pará',
    'Paraíba',
    'Paraná',
    'Pernambuco',
    'Piauí',
    'Rio de Janeiro',
    'Rio Grande do Norte',
    'Rio Grande do Sul',
    'Rondônia',
    'Roraima',
    'Santa Catarina',
    'São Paulo',
    'Sergipe',
    'Tocantins',
  ];
}