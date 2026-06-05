# MERN Shop — Flutter Frontend Prototype

Protótipo de e-commerce desenvolvido em Flutter. Apenas frontend, sem backend real.

## Estrutura do Projeto

```
lib/
├── main.dart                  # Entry point e configuração de rotas
├── theme.dart                 # Tema global (cores, botões, inputs)
├── models/
│   ├── product.dart           # Modelo de produto + dados mock
│   └── cart_item.dart         # Modelo de item do carrinho
├── providers/
│   ├── auth_provider.dart     # Estado de autenticação (mock)
│   └── cart_provider.dart     # Estado do carrinho
├── screens/
│   ├── home_screen.dart       # Página inicial com grid de produtos
│   ├── login_screen.dart      # Página de login
│   ├── register_screen.dart   # Página de cadastro
│   ├── product_screen.dart    # Detalhe do produto
│   └── cart_screen.dart       # Carrinho + resumo do pedido
└── widgets/
    ├── app_header.dart        # Cabeçalho com logout
    └── product_card.dart      # Card do produto no grid
```

## Páginas

| Rota        | Tela                  |
|-------------|-----------------------|
| `/`         | Home (Grid de produtos)|
| `/login`    | Login                 |
| `/register` | Cadastro              |
| `/product`  | Detalhe do produto    |
| `/cart`     | Carrinho              |

## Funcionalidades

- ✅ Grid responsivo de produtos (2/3/4 colunas)
- ✅ Busca de produtos por nome
- ✅ Detalhe do produto com seletor de quantidade
- ✅ Carrinho com controle de itens
- ✅ Resumo do pedido (subtotal, frete, impostos)
- ✅ Login/Cadastro mock (sem backend)
- ✅ Header dinâmico com logout
- ✅ Navegação completa entre telas

## Como Rodar

### Pré-requisitos
- Flutter SDK 3.0+
- Dart 3.0+

### Instalação

```bash
# Instalar dependências
flutter pub get

# Rodar no navegador (web)
flutter run -d chrome

# Rodar no emulador/dispositivo
flutter run
```

## Dependências

```yaml
provider: ^6.1.1         # Gerenciamento de estado
go_router: ^13.0.0       # Roteamento (opcional, app usa Navigator)
cached_network_image: ^3.3.1  # Cache de imagens
```

## Observações

- Todos os dados são **mock** (hardcoded) — nenhuma API real é chamada
- O login/cadastro apenas simula autenticação e salva o nome do usuário no estado
- As imagens usam `picsum.photos` como placeholder
- Para adicionar backend: substitua os providers por chamadas à API real
