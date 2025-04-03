# Onfly Viagens App

## Visão Geral

O aplicativo permite aos usuários registrar, visualizar, editar e excluir despesas, além de gerenciar cartões para pagamento. Desenvolvido com Flutter seguindo os princípios de Clean Architecture, o app proporciona uma experiência fluida tanto online quanto offline.

## Funcionalidades Principais

### Autenticação
- Login  com email e senha


### Gerenciamento de Despesas
- Visualização de todas as despesas em uma lista organizada
- Adição de novas despesas com categorização
- Edição de despesas existentes
- Exclusão de despesas
- Marcação de despesas como reembolsáveis
- Acompanhamento do status de reembolso


### Resumo Financeiro
- Visão geral das despesas totais
- Resumo de reembolsos pendentes
- Relatório detalhado categorizado por tipo de despesa


### Gestão de Cartões
- Visualização dos cartões disponíveis


### Sincronização de Dados
- Funcionamento offline com sincronização automática
- Detecção de conectividade para operações online/offline
- Resolução de conflitos de dados

## Arquitetura

O projeto segue os princípios da Clean Architecture, dividindo o código em camadas bem definidas para garantir separação de responsabilidades, testabilidade e manutenibilidade.


### Diagrama de Arquitetura
```
lib/
├── core/
│   ├── base/
│   ├── routes/
│   ├── services/
│   ├── theme/
│   ├── utils/
│   └── core.dart
├── modules/
│   ├── data/
│   │   ├── datasource/
│   │   ├── model/
│   │   ├── repository/
│   │   └── data.dart
│   ├── domain/
│   │   ├── entity/
│   │   ├── repository/
│   │   ├── usecase/
│   │   └── domain.dart
│   ├── infra/
│   │   ├── database/
│   │   ├── datasource/
│   │   └── mock/
│   └── presentation/
│       ├── bloc/
│       ├── ui/
│       └── page/

```
## Configuração do Ambiente

### Pré-requisitos
- Flutter SDK (versão 3.10.0 ou superior)
- Dart SDK (versão 3.0.0 ou superior)
- Android Studio / VS Code
- Emulador Android / iOS ou dispositivo físico

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/Matheus-o-alves/App-Viagens

```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```


## Testes

O projeto possui testes unitários, de integração e de widgets para garantir a qualidade do código.

### Executando Testes Unitários

```bash
flutter test
```

### Executando Testes de Cobertura

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Gerando Mocks para Testes

O projeto utiliza Mockito para a criação de mocks. Para gerar os arquivos de mock, execute:

```bash
flutter pub run build_runner build
```

### Estrutura de Testes

```
test/
├── core/
├── modules/
│   ├── data/
│   │   ├── datasource/
│   │   ├── model/
│   │   └── repository/
│   ├── domain/
│   │   ├── entity/
│   │   └── usecase/
│   └── presentation/
│       ├── bloc/
│       └── pages/

```

## Dependências Principais

- **flutter_bloc**: Gerenciamento de estado
- **get_it**: Injeção de dependências
- **dartz**: Programação funcional (Either para tratamento de erros)
- **http**: Requisições HTTP
- **sqflite**: Banco de dados local
- **intl**: Internacionalização e formatação
- **mockito**: Criação de mocks para testes
- **bloc_test**: Testes para BLoCs


## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE.md](LICENSE.md) para detalhes.

