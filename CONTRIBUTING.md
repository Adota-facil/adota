# Contribuindo com o Adota Fácil

## Antes de começar

- `flutter pub get`
- Confirma que está com uma versão de Flutter/Dart parecida com a do resto do time (`flutter --version`) — evita diffs de formatação sem relação nenhuma com a mudança que você fez.

## Branches

- `main` fica sempre estável — o que está lá roda sem susto.
- Uma branch por funcionalidade ou correção, criada a partir da `main` atualizada:

```
git checkout main
git pull
git checkout -b feature/nome-da-funcionalidade
```

- Prefixos sugeridos: `feature/...`, `fix/...`, `docs/...` — deixa claro o tipo de mudança já no nome.

## Commits

- Mensagem curta, no imperativo, descrevendo o que a mudança faz: *"Adiciona filtro de categoria na busca"*, não *"mudanças"* ou *"fix"*.
- Prefira vários commits pequenos a um gigante no final — fica mais fácil revisar e, se precisar, reverter só um pedaço.

## Antes de dar push

Nessa ordem:

1. **`flutter analyze`** — pega import errado, parâmetro faltando, método que não existe. É o tipo de erro que, sem isso, só aparece quando o outro dev tenta rodar o projeto.
2. `flutter pub get`, se você mexeu no `pubspec.yaml`.
3. Testa a tela que você mexeu com **hot restart** (não só hot reload) — hot reload não recarrega mudança de `Provider`/dependência, então pode "funcionar" no seu teste e quebrar pra quem abrir o app do zero.

## Merge / Pull Request

- Puxa a `main` mais recente antes de abrir o PR (`git pull origin main`).
- Se der conflito, resolve com calma — e depois de resolver, roda `flutter analyze` de novo. Um merge mal resolvido nem sempre quebra a compilação: o código continua "válido", só que pode ter voltado uma versão antiga de um método ou perdido uma linha, sem o compilador reclamar de nada. (Foi exatamente isso que já aconteceu nesse projeto.)
- Depois de resolver um conflito num arquivo, dá uma lida geral nele — não só nas linhas marcadas — pra garantir que nada importante do "outro lado" ficou pra trás.

## Onde perguntar

- Dúvida sobre padrão de código, estrutura de pasta, ou esquema do banco → primeiro lugar é o [`docs/arquitetura.md`](./docs/arquitetura.md).
- Bug estranho logo depois de um merge (dado sumiu, tela vazia sem erro) → suspeita inicial: `orderBy`/índice do Firestore ou Provider duplicado — tem uma seção inteira sobre isso no `arquitetura.md`.