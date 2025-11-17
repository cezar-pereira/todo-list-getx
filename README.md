# Todo List - Aplicativo Flutter

Aplicativo Flutter desenvolvido seguindo Clean Architecture, que exibe uma lista de tarefas obtidas de uma API REST com suporte offline-first.

## 📋 Características

- ✅ Clean Architecture (camadas: data, domain, presentation)
- ✅ Princípios SOLID aplicados
- ✅ Integração com API REST
- ✅ Autenticação automática
- ✅ Cache local (offline-first)
- ✅ Gerenciamento de estado com GetX
- ✅ Injeção de dependências com GetX
- ✅ Navegação com GetX
- ✅ Testes unitários e de widget

## 🏗️ Arquitetura

O projeto segue Clean Architecture com as seguintes camadas:

### Domain (Camada de Domínio)
- **Entities**: Entidades de negócio (`TodoEntity`, `AuthEntity`)
- **Repositories**: Interfaces dos repositórios

### Data (Camada de Dados)
- **Models**: Modelos de dados com serialização JSON
- **DataSources**: 
  - Remote: Comunicação com API
  - Local: Cache com SharedPreferences
- **Repositories**: Implementação dos repositórios

### Presentation (Camada de Apresentação)
- **Controllers**: Controllers GetX para gerenciamento de estado
- **Pages**: Telas da aplicação

### Core
- **RestClient**: Interface e implementação com Dio para requisições HTTP

## 🚀 Como executar

### Pré-requisitos

- Flutter SDK 3.9.2 ou superior
- Dart SDK
- Android Studio / VS Code com extensões Flutter
- Emulador Android/iOS ou dispositivo físico

### Instalação

1. Clone o repositório:
```bash
git clone <url-do-repositorio>
cd todolist
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```

## 🧪 Testes

### Executar todos os testes:
```bash
flutter test
```

### Executar testes específicos:

**Teste unitário (TodoModel):**
```bash
flutter test test/data/models/todo_model_test.dart
```

**Teste de widget (TodoListPage):**
```bash
flutter test test/presentation/pages/todo_list_page_test.dart
```

## 📱 Funcionalidades

### Lista de Tarefas
- Exibe lista de tarefas com título e status (concluída/pendente)
- Indicador visual de conexão (online/offline)
- Botão de atualização para recarregar a lista

### Offline-First
- Se não houver conexão, carrega tarefas do cache local
- Ao voltar a conexão, sincroniza e busca da API
- Cache persistente usando SharedPreferences

### Autenticação
- Autenticação automática ao iniciar o aplicativo
- Token armazenado localmente
- Reautenticação automática quando necessário

## 🔧 Configuração da API

O aplicativo está configurado para usar as seguintes rotas:

### Autenticação
- **URL**: `http://lf.infornet.com.br:3010/auth`
- **Método**: POST
- **Headers**:
  - `x-login`: testeFlutter
  - `x-senha`: #Qsy&_@73bh

### Lista de Tarefas
- **URL**: `http://localhost:3000/todos`
- **Método**: GET
- **Headers**:
  - `Authorization`: Bearer `<TOKEN>`

**Nota**: Para testar em um dispositivo físico, você precisará ajustar a URL `localhost:3000` para o IP da sua máquina na rede local.

## 📦 Dependências Principais

- **get**: Gerenciamento de estado, DI e navegação
- **dio**: Cliente HTTP
- **shared_preferences**: Armazenamento local
- **connectivity_plus**: Verificação de conectividade

## 🧩 Estrutura do Projeto

```
lib/
├── core/
│   ├── rest_client/
│   │   ├── rest_client.dart
│   │   ├── dio_rest_client.dart
│   │   └── rest_client_response_model.dart
│   └── app_multipart_file.dart
├── domain/
│   ├── entities/
│   │   ├── todo_entity.dart
│   │   └── auth_entity.dart
│   └── repositories/
│       ├── todo_repository.dart
│       └── auth_repository.dart
├── data/
│   ├── models/
│   │   ├── todo_model.dart
│   │   └── auth_model.dart
│   ├── datasources/
│   │   ├── todo_remote_datasource.dart
│   │   ├── todo_local_datasource.dart
│   │   ├── auth_remote_datasource.dart
│   │   └── auth_local_datasource.dart
│   └── repositories/
│       ├── todo_repository_impl.dart
│       └── auth_repository_impl.dart
├── presentation/
│   ├── controllers/
│   │   └── todo_controller.dart
│   └── pages/
│       └── todo_list_page.dart
├── app_module.dart
└── main.dart
```

## 📝 Notas de Desenvolvimento

- O projeto utiliza GetX para gerenciamento de estado, injeção de dependências e navegação
- A arquitetura segue os princípios SOLID
- O cache local é atualizado automaticamente quando há conexão
- Os testes cobrem casos básicos de uso

## 🔍 Troubleshooting

### Erro de conexão com API
- Verifique se a API está rodando
- Para dispositivo físico, ajuste a URL `localhost:3000` para o IP da sua máquina
- Verifique as credenciais de autenticação

### Erro ao executar testes
Certifique-se de que todas as dependências estão instaladas:
```bash
flutter pub get
```

## 👨‍💻 Autor

Desenvolvido como teste técnico para Desenvolvedor Flutter.

## 📄 Licença

Este projeto é privado e desenvolvido para fins de avaliação técnica.
