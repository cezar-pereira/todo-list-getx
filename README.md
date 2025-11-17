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
git clone https://github.com/cezar-pereira/todo-list-getx
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

## 📱 Funcionalidades

### Lista de Tarefas
- Exibe lista de tarefas com título e status (concluída/pendente)
- Indicador visual de conexão (online/offline)
- Botão de atualização para recarregar a lista

### Offline-First
- Se não houver conexão, carrega tarefas do cache local
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
- **URL**: `[http://localhost:3000](http://lf.infornet.com.br:3010)/todos`
- **Método**: GET
- **Headers**:
  - `Authorization`: Bearer `<TOKEN>`

  
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
├── domain/
│   ├── entities/
│   └── repositories/
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
├── presentation/
│   ├── controllers/
│   └── pages/
├── app_module.dart
└── main.dart
```

## 📝 Notas de Desenvolvimento

- O projeto utiliza GetX para gerenciamento de estado, injeção de dependências e navegação
- A arquitetura segue os princípios SOLID
- O cache local é atualizado automaticamente quando há conexão
- Os testes cobrem casos básicos de uso
