
# 📱 Eventos Locais - App Flutter

Um aplicativo moderno e elegante para gerenciamento de eventos locais, desenvolvido em Flutter seguindo boas práticas de desenvolvimento e arquitetura limpa.

## 🚀 Sobre o Projeto

O **Eventos Locais** é uma aplicação móvel que permite aos usuários criar, visualizar, editar e excluir eventos de forma simples e intuitiva. O app foi desenvolvido com foco na experiência do usuário e na organização do código, implementando padrões de desenvolvimento modernos.

### ✨ Funcionalidades

- 📋 **Lista de Eventos**: Visualize todos os eventos cadastrados em uma interface limpa e organizada
- ➕ **Criar Eventos**: Adicione novos eventos com nome, descrição, tipo e data
- ✏️ **Editar Eventos**: Modifique informações de eventos existentes
- 🗑️ **Excluir Eventos**: Remova eventos com confirmação de segurança
- 📅 **Validação de Data**: Apenas datas futuras ou presentes são aceitas
- 🎯 **Tipos de Evento**: Categorize eventos como Esportivo, Cultural, Educacional ou personalizado
- 💾 **Persistência Local**: Dados salvos automaticamente no dispositivo
- 🎨 **Interface Moderna**: Design seguindo Material Design 3

## 🏗️ Arquitetura

O projeto segue os princípios da **Clean Architecture** e boas práticas de desenvolvimento Flutter:

```
lib/
├── core/                     # Configurações centrais
│   ├── constants/           # Constantes da aplicação
│   ├── routes/             # Sistema de rotas
│   └── theme/              # Tema e estilos globais
├── features/               # Funcionalidades por domínio
│   ├── event/             # Domínio de eventos
│   │   ├── domain/        # Modelos e entidades
│   │   └── presentation/  # Páginas e widgets
│   └── splash/            # Tela inicial
└── shared/                # Componentes compartilhados
    ├── services/         # Serviços (armazenamento, etc.)
    └── widgets/          # Widgets reutilizáveis
```

### 📋 Padrões Implementados

- **Clean Architecture**: Separação clara de responsabilidades
- **Repository Pattern**: Abstração da fonte de dados
- **Singleton Pattern**: Gerenciamento de instâncias únicas
- **Lifting State Up**: Elevação de estado para componentes pais
- **Separation of Concerns**: Cada classe com responsabilidade única

## 🛠️ Tecnologias Utilizadas

- **Flutter** 3.x - Framework de desenvolvimento
- **Dart** - Linguagem de programação
- **Material Design 3** - Sistema de design
- **SharedPreferences** - Armazenamento local
- **Provider/setState** - Gerenciamento de estado

## 📦 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
  cupertino_icons: ^1.0.6

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## 🚀 Como Executar

### Pré-requisitos

- Flutter 3.x instalado
- Android Studio ou VS Code
- Emulador Android/iOS ou dispositivo físico

### Passos para execução

1. **Clone o repositório**
  ```bash
  git clone https://github.com/Sheila724/DSM5-DispositivosMoveis.git
  cd DSM5-DispositivosMoveis
  ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**
   ```bash
   flutter run
   ```

## 📱 Telas do Aplicativo

### 🎬 Splash Screen
- Tela inicial com logo animado
- Carregamento dos serviços essenciais
- Transição suave para a lista de eventos

### 📋 Lista de Eventos
- Visualização de todos os eventos em cards elegantes
- Ações rápidas de editar/excluir via menu
- Pull-to-refresh para atualizar dados
- Estado vazio com call-to-action

### 📝 Formulário de Evento
- Criação e edição de eventos
- Validação em tempo real
- Seletor de data com restrições
- Dropdown de tipos com opção personalizada
- Feedback visual de salvamento

## 🎨 Design System

### Cores (Material Design 3)
- **Primary**: #6750A4 (Roxo moderno)
- **Secondary**: #625B71 (Cinza elegante)
- **Surface**: #FFFBFE (Branco suave)
- **Error**: #BA1A1A (Vermelho de alerta)

### Tipografia
- Fontes seguindo Material Design 3
- Hierarquia clara de títulos e textos
- Legibilidade otimizada

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 Contato

Para dúvidas ou sugestões, entre em contato através do GitHub.

---

⭐ **Desenvolvido com ❤️ usando Flutter**
