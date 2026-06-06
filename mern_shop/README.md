# MERN Shop v2 — Dark Luxury E-commerce Flutter Prototype

Design: **Dark Luxury Editorial** — fundo near-black, acentos dourados/âmbar, tipografia Playfair Display + DM Sans.

---

## Estrutura do Projeto

```
lib/
├── main.dart
├── theme.dart                        # Cores, gradientes, decorações globais
├── models/
│   ├── product.dart                  # Produto + 10 mock products
│   ├── order.dart                    # Pedido, status, endereço, pagamento
│   └── user.dart                     # Usuário + mock DB
├── providers/
│   ├── auth_provider.dart            # Login, cadastro, perfil, avatar
│   ├── cart_provider.dart            # Carrinho com cálculo de frete e impostos
│   ├── order_provider.dart           # Criar e rastrear pedidos
│   └── product_provider.dart        # CRUD de produtos (admin)
├── screens/
│   ├── home_screen.dart              # Grid + filtro por categoria + busca
│   ├── login_screen.dart             # Login dividido (decorativo + form)
│   ├── register_screen.dart         # Cadastro com validação e termos
│   ├── product_screen.dart          # Detalhe completo do produto
│   ├── cart_screen.dart             # Carrinho + Endereço + Pagamento (3 steps)
│   ├── order_success_screen.dart    # Confirmação do pedido com rastreio
│   ├── orders_screen.dart           # Lista de pedidos com stepper
│   ├── profile_screen.dart          # Perfil + upload de avatar + edição
│   └── admin/
│       └── admin_screen.dart        # Dashboard admin: produtos + pedidos
└── widgets/
    ├── app_header.dart              # Header com dropdown de usuário + logout
    ├── product_card.dart            # Card com hover, badges, low-stock
    ├── user_avatar.dart             # Avatar com iniciais ou imagem local
    └── order_status_stepper.dart   # Stepper animado de status do pedido
```

---

## Páginas e Rotas

| Rota             | Tela                        | Acesso        |
|------------------|-----------------------------|---------------|
| `/`              | Home (grid + filtros)       | Público       |
| `/login`         | Login                       | Público       |
| `/register`      | Cadastro                    | Público       |
| `/product`       | Detalhe do produto          | Público       |
| `/cart`          | Carrinho + Checkout         | Público/Login |
| `/order-success` | Confirmação de pedido       | Login         |
| `/orders`        | Meus pedidos                | Login         |
| `/profile`       | Perfil do usuário           | Login         |
| `/admin`         | Painel administrativo       | Admin         |

---

## Funcionalidades

### Usuário
- ✅ Login / Cadastro com validação completa
- ✅ Upload de foto de perfil (image_picker)
- ✅ Edição de nome, telefone e bio
- ✅ Avatar com iniciais como fallback
- ✅ Dropdown no header com logout

### Produtos
- ✅ Grid responsivo com 10 produtos mock
- ✅ Filtro por categoria (chips horizontais)
- ✅ Busca por nome/categoria
- ✅ Badges: NOVO, % desconto, baixo estoque
- ✅ Detalhe do produto com avaliações e parcelas

### Carrinho & Compra
- ✅ Carrinho com controle de quantidade
- ✅ Frete grátis acima de R$ 200
- ✅ Cálculo de impostos (6%)
- ✅ Checkout em 3 etapas: Carrinho → Endereço → Pagamento
- ✅ 4 formas de pagamento: Crédito, Débito, Pix, Boleto
- ✅ Simulação de cartão visual
- ✅ Pedido confirmado com stepper de rastreio

### Admin (admin@mernshop.com / admin123)
- ✅ Dashboard com estatísticas (produtos, pedidos, receita)
- ✅ Adicionar / Editar / Excluir produtos
- ✅ Gerenciar status dos pedidos
- ✅ Badge visual de admin no perfil

---

## Como Rodar

```bash
# 1. Instalar dependências
flutter pub get

# 2. Rodar na web
flutter run -d chrome

# 3. Rodar no dispositivo/emulador
flutter run
```

### Contas de demonstração

| Tipo    | E-mail               | Senha    |
|---------|----------------------|----------|
| Admin   | admin@mernshop.com   | admin123 |
| Cliente | joao@email.com       | 123456   |

---

## Dependências

```yaml
provider: ^6.1.1              # State management
image_picker: ^1.0.7          # Upload de avatar
intl: ^0.19.0                 # Formatação de datas
uuid: ^4.3.3                  # IDs únicos para pedidos
cached_network_image: ^3.3.1  # Cache de imagens
flutter_animate: ^4.5.0       # Animações
google_fonts: ^6.2.1          # Playfair Display + DM Sans
shimmer: ^3.0.0               # Skeleton loading
```

---

## Próximos Passos (Backend)

Para conectar a um backend real, substitua:
- `providers/auth_provider.dart` → chamadas HTTP para `/api/auth`
- `providers/product_provider.dart` → `/api/products`
- `providers/order_provider.dart` → `/api/orders`
- `models/user.dart` (mockUserDb) → MongoDB via API REST
