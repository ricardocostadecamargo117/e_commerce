# MERN Shop — Backend

API REST com Node.js, Express e MongoDB Atlas.

---

## Estrutura

```
backend/
├── server.js           # Entry point
├── seeder.js           # Popula o banco com dados iniciais
├── .env                # Variáveis de ambiente (NÃO subir no GitHub)
├── config/
│   └── db.js           # Conexão com MongoDB Atlas
├── models/
│   ├── User.js
│   ├── Product.js
│   └── Order.js
├── controllers/
│   ├── authController.js
│   ├── userController.js
│   ├── productController.js
│   └── orderController.js
├── routes/
│   ├── authRoutes.js
│   ├── userRoutes.js
│   ├── productRoutes.js
│   └── orderRoutes.js
└── middleware/
    └── authMiddleware.js
```

---

## Passo a passo para rodar

### 1. Configurar o MongoDB Atlas

1. Acesse [mongodb.com/atlas](https://www.mongodb.com/atlas) e crie uma conta gratuita
2. Crie um **Cluster gratuito** (M0)
3. Em **Database Access** → crie um usuário com senha
4. Em **Network Access** → adicione `0.0.0.0/0` (permite qualquer IP)
5. Em **Connect** → escolha "Drivers" → copie a connection string
6. Cole no arquivo `.env` substituindo `SEU_USUARIO` e `SUA_SENHA`

### 2. Instalar dependências

```bash
cd backend
npm install
```

### 3. Popular o banco (apenas na primeira vez)

```bash
node seeder.js
```

Isso cria:
- Admin: `admin@mernshop.com` / `admin123`
- Cliente: `joao@email.com` / `123456`
- 8 produtos iniciais

### 4. Rodar o servidor

```bash
# Desenvolvimento (reinicia automaticamente ao salvar)
npm run dev

# Produção
npm start
```

O servidor sobe em `http://localhost:5000`

---

## Endpoints da API

### Auth
| Método | Rota                  | Descrição         | Auth |
|--------|-----------------------|-------------------|------|
| POST   | /api/auth/register    | Cadastrar usuário | ❌   |
| POST   | /api/auth/login       | Login             | ❌   |

### Usuários
| Método | Rota                  | Descrição          | Auth   |
|--------|-----------------------|--------------------|--------|
| GET    | /api/users/profile    | Ver perfil         | ✅     |
| PUT    | /api/users/profile    | Editar perfil      | ✅     |
| GET    | /api/users            | Listar usuários    | Admin  |

### Produtos
| Método | Rota                  | Descrição          | Auth   |
|--------|-----------------------|--------------------|--------|
| GET    | /api/products         | Listar produtos    | ❌     |
| GET    | /api/products/:id     | Detalhe            | ❌     |
| POST   | /api/products         | Criar produto      | Admin  |
| PUT    | /api/products/:id     | Editar produto     | Admin  |
| DELETE | /api/products/:id     | Excluir produto    | Admin  |

### Pedidos
| Método | Rota                    | Descrição            | Auth   |
|--------|-------------------------|----------------------|--------|
| POST   | /api/orders             | Criar pedido         | ✅     |
| GET    | /api/orders/my          | Meus pedidos         | ✅     |
| GET    | /api/orders/:id         | Detalhe do pedido    | ✅     |
| GET    | /api/orders             | Todos os pedidos     | Admin  |
| PUT    | /api/orders/:id/status  | Atualizar status     | Admin  |

---

## Exemplo de requisição (login)

```json
POST /api/auth/login
Content-Type: application/json

{
  "email": "admin@mernshop.com",
  "password": "admin123"
}
```

Resposta:
```json
{
  "_id": "...",
  "name": "Admin",
  "email": "admin@mernshop.com",
  "role": "admin",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

O `token` deve ser enviado nas rotas protegidas no header:
```
Authorization: Bearer SEU_TOKEN_AQUI
```

---

## Próximo passo — Conectar ao Flutter

No Flutter, substitua os providers mock pelas chamadas HTTP:

```dart
// Exemplo: login real
final response = await http.post(
  Uri.parse('http://localhost:5000/api/auth/login'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({'email': email, 'password': password}),
);
```
