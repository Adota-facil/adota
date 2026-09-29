# Arquitetura

Esse documento explica os padrões usados no código do Adota Fácil e registra decisões e problemas já resolvidos, para quem for mexer no projeto depois — seja você daqui a alguns meses, seja outra pessoa entrando agora.

## Padrão: Model + Controller + Repository

Cada funcionalidade segue essa divisão:

- **Model** (`lib/models/*.dart`) — entidade pura de dados (`PetModel`, `UsuarioModel`). Sabe se converter de/para o formato do Firestore (`fromFirestore`/`toFirestore` ou `fromMap`/`toMap`) e tem um `copyWith` para criar cópias modificadas.
- **Repository** (`lib/models/repositories/*.dart`) — abstrai o acesso a dados. Uma interface abstrata (o contrato) + uma implementação concreta (`*Impl`) que fala com o Firestore. Ex: `AnimalRepository` (interface) / `AnimalRepositoryImpl` (Firestore).
- **Controller** (`lib/controllers/*.dart`) — um `ChangeNotifier`. Contém a lógica de apresentação: chama o repository, guarda estado de `carregando`/`erro`, expõe getters para a View consumir.
- **View** (`lib/view/pages/*.dart`, `lib/view/widgets/*.dart`) — só desenha a UI a partir do que o Controller expõe. Não fala com Firestore diretamente.

## Princípios SOLID aplicados

### DIP (Dependency Inversion)

Controllers recebem as dependências pelo **construtor**, sempre como interfaces abstratas, nunca como classes concretas:

```dart
HomeController(this._repository, this._estrategiaFoto, this._analytics, {...});
//              ^ AnimalRepository (interface), não AnimalRepositoryImpl
```

O Controller não sabe se os dados vêm do Firestore, se a foto vira Base64 ou vai pro Storage, nem qual provedor de analytics está registrando eventos — só conhece os contratos. Quem decide a implementação concreta é o **`main.dart`**, o "composition root" do app: é o único lugar que deveria instanciar `AnimalRepositoryImpl()`, `ArmazenamentoBase64()`, etc.

### ISP (Interface Segregation)

Interfaces grandes são quebradas em pedaços menores quando fazem sentido, em vez de uma única interface "faz tudo":

- `AnimalRepository` é a junção de `AnimalReader` (métodos de leitura) + `AnimalWriter` (métodos de escrita).
- `HomeController` implementa `ListaAnimaisController` + `CadastroAnimalController` (interfaces segregadas para listagem e cadastro), mesmo sendo uma classe só — deixa explícito que a classe cumpre dois papéis que poderiam virar duas classes menores se crescerem demais.

### Callback/injeção em vez de acoplamento direto

Quando um Controller precisa avisar outra parte do app sobre uma mudança, sem depender dela diretamente, ele recebe uma **função** pelo construtor, não uma referência à outra classe:

```dart
HomeController(..., {void Function(List<PetModel>)? aoAtualizarAnimais});
```

O `HomeController` não sabe que `NotificacaoController` existe — só chama a função que recebeu. É o `main.dart` que conecta as duas pontas. Use esse padrão sempre que dois Controllers precisarem "conversar" sem se tornarem dependentes um do outro.

## Duas formas de manter a tela atualizada

O projeto usa dois padrões diferentes, cada um no lugar certo:

**1. Busca uma vez + callback manual** (`HomeController`, `NotificacaoController`)
O Controller busca os dados quando mandado (`carregarAnimais()`) e some com eles até a próxima chamada explícita. Bom para listas que não precisam refletir mudanças de outros usuários em tempo real.

**2. Stream em tempo real** (`PerfilUsuarioView` + `UsuarioRepository.observarUsuario`)
A tela observa o documento do Firestore diretamente via `StreamBuilder`. Qualquer mudança no banco (inclusive escrita feita pelo próprio app, como trocar a foto de perfil) aparece na tela sozinha, sem precisar de nenhum sistema de aviso manual. Ver a seção de armadilhas abaixo para os cuidados ao usar `StreamBuilder`.

Ao adicionar uma tela nova, escolha o padrão pensando se o dado precisa refletir mudanças externas em tempo real (stream) ou só muda por ação do próprio usuário dentro do fluxo (busca + callback já resolve).

## Esquema do banco (Firestore)

### `animais`
| Campo | Tipo | Obs |
|---|---|---|
| `nome`, `especie`, `raca`, `porte`, `idade`, `genero` | string | |
| `statusSaude` | string | ex: "Castrado, Vacinado" |
| `descricao`, `localizacao` | string | |
| `fotoUrl` / `fotoBase64` | string | uma das duas, dependendo da estratégia de armazenamento |
| `fotos` / `fotosBase64` | array\<string\> | galeria |
| `adotado` | bool | |
| `anuncianteId` | string | uid do usuário que cadastrou |
| `criadoEm` | timestamp | **nullable** — ver armadilhas |
| `usuarioNome` | string | nome do anunciante (adicionado depois, ver `PerfilPetController`) |

### `usuarios`
| Campo | Tipo | Obs |
|---|---|---|
| `nome`, `email`, `telefone` | string | |
| `tipo` | string | `'adotante'` \| `'anunciante'` \| `'ambos'` |
| `tipoAnunciante` | string? | `'Protetor Independente'` \| `'ONG'` \| `'Abrigo'` — só quando `tipo` inclui anunciante |
| `estado`, `cidade` | string | campos separados (não é uma `localizacao` única) |
| `fotoUrl` / `fotoBase64` | string | |
| `favoritos` | array\<string\> | ids de pets, direto no documento (sem subcoleção) |
| `criadoEm` | timestamp | |

### `avaliacoes`
| Campo | Tipo | Obs |
|---|---|---|
| `anuncianteId`, `avaliadorId` | string | |
| `nota` | number | |
| `comentario` | string | |
| `criadoEm` | timestamp | |

## Como adicionar uma funcionalidade nova

1. **Model** — campos + `fromFirestore`/`toFirestore` + `copyWith`.
2. **Repository** — método novo na interface abstrata, depois na implementação Firestore.
3. **Controller** — lógica de apresentação (`carregando`, `erro`, ação).
4. **Provider** — se o Controller precisa viver além de uma tela só, registra no `main.dart` (repare a ordem: um Controller que lê outro via `context.read()` no `create` precisa vir **depois** dele na lista de `providers`).
5. **View** — consome o Controller (`context.watch`/`context.read`/`Consumer`).

## Convenções

- Nomes de classes, métodos e variáveis em **português**.
- `*View` para telas (`PerfilUsuarioView`), `*Controller` para os ChangeNotifiers, `*Repository`/`*RepositoryImpl` para acesso a dados.
- Arquivos em `snake_case`, mas **atenção**: alguns arquivos existentes fogem da convenção (`appBar_Widget.dart` com maiúscula, `ajuste_foto_widget.dart` cujo arquivo tem "_widget" mas a classe dentro chama-se só `AjusteFoto`). Sempre confira o nome real do arquivo antes de importar — já causou mais de um erro de compilação no projeto.
- Cor primária do app: `Color(0xFFEF9737)` (laranja).

## Armadilhas conhecidas (lições já aprendidas nesse projeto)

Essas não são teóricas — cada uma já causou um bug real aqui.

**Firestore `orderBy` exclui documentos em silêncio.** Se um documento não tem o campo usado no `orderBy`, ele simplesmente não aparece no resultado — sem erro. Já causou pets cadastrados sumirem da lista. Quando o campo não é garantido em todo documento (como `criadoEm`, que é nullable), busque sem `orderBy` e ordene em Dart depois.

**`where` + `orderBy` em campos diferentes exige índice composto no Firestore.** Sem o índice, a consulta falha com `[cloud_firestore/failed-precondition]`. Para listas pequenas (como "pets de um anunciante"), evite o índice ordenando em Dart em vez de no Firestore.

**`StreamBuilder`: nunca crie o `Stream` direto dentro do `build()`.** Uma expressão como `stream: repositorio.observarAlgo(id)` escrita direto no `build()` cria uma instância nova a cada rebuild — o Flutter entende como um stream diferente e reinscreve do zero, resetando o estado no meio do caminho (inclusive interrompendo gestos como scroll). Guarde o `Stream` num campo de estado e só recrie se o parâmetro (ex: o id) mudar de verdade.

**`AuthController` precisa escutar `authStateChanges()`, não só os próprios métodos de login/logout.** Se o `ChangeNotifier` de autenticação só chama `notifyListeners()` quando o próprio app chama `login()`/`logout()`, uma sessão restaurada automaticamente pelo Firebase (ex: reabrir o app já logado) nunca avisa o resto do app — telas que dependem desse estado ficam presas achando que ninguém está logado.

**`PageView` (sem `.builder`) constrói todos os filhos de uma vez**, não só o visível. Um Controller que busca dados no `initState` de uma dessas páginas roda muito cedo, possivelmente antes do Firebase terminar de restaurar a sessão — outro motivo para preferir Stream/Provider reativo a "buscar uma vez no initState" nessas páginas.

**`NotificationListener<ScrollNotification>` dentro do `PageView` precisa filtrar por eixo.** Sem checar `notification.metrics.axis == Axis.vertical`, o listener também captura o swipe horizontal de troca de aba do próprio `PageView`, misturando os dois gestos.

**Firebase exige login recente para excluir conta.** `currentUser.delete()` lança `requires-recent-login` se a sessão não é "recente" o suficiente — a mensagem de erro já trata isso, mas não existe um fluxo de reautenticação implementado ainda; se aparecer esse erro, a saída é sair e entrar de novo antes de excluir.

**Excluir conta não é cascata.** Apagar o documento do usuário não apaga os pets/solicitações vinculados a ele — ficariam com `anuncianteId`/`adotanteId` "órfão". Resolver isso direito exigiria uma Cloud Function no backend; não está implementado.