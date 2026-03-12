---
name: nextjs-to-tanstack-migration
description: Assist with migrating the d2c-trade-in Next.js App Router application to TanStack Start.
---

# Next.js to TanStack Start Migration

This skill assists with migrating the d2c-trade-in application from Next.js App Router to TanStack Start.

## 📚 Detailed Documentation

This guide provides a high-level overview of the migration process. For in-depth information on specific topics, refer to these detailed guides:

### TanStack Router
- **[File-Based Routing Structure](docs/router/file-based-routing-structure.md)** - Comprehensive guide to file-based routing, directory vs flat routes, and route organization patterns
- **[Data Loading](docs/router/data-loading.md)** - Route loaders, caching strategies, SWR patterns, search params, context, error handling
- **[Navigation](docs/router/navigation.md)** - Link components, useNavigate hook, relative navigation, search params, active states

### TanStack Start
- **[Server Functions](docs/start/server-functions.md)** - Creating server functions, validation with Zod, form handling, error handling, streaming, middleware
- **[Execution Model](docs/start/execution-model.md)** - Understanding where code runs, isomorphic by default, server-only vs client-only patterns, security considerations

### Forms
- **[Basic Concepts](docs/forms/basic-concepts.md)** - TanStack Form fundamentals: useForm hook, Field components, field state, validation with Zod/Valibot, reactivity, array fields

---

## Project Context

### Current State
- **App**: `apps/d2c-trade-in/` - Next.js App Router application (port 3020)
- **Architecture**: Pure App Router with React Server Components
- **Styling**: Tailwind CSS + Radix UI components
- **Forms**: React Hook Form with Zod validation
- **Data Fetching**: Currently using Next.js data fetching patterns

### Migration Target
- **New Location**: `apps/d2c-trade-in-tanstack/` (new directory)
- **Framework**: TanStack Start with TanStack Router
- **Port**: 3020 (maintain current port)
- **Preserve**: UI components, styling, business logic
- **Change**: Routing system, data loading patterns, server functions, form library (migrating to TanStack Form)

## Official Migration Guide

This guide provides a step-by-step process to migrate from Next.js App Router to **TanStack Start**.

### Step-by-Step (Basics)

#### Prerequisites

Typical Next.js App Router structure:
```txt
├── next.config.ts
├── package.json
├── src
│   └── app
│       ├── layout.tsx
│       └── page.tsx
└── tsconfig.json
```

#### 1. Remove Next.js

```sh
npm uninstall @tailwindcss/postcss next
rm postcss.config.* next.config.*
```

#### 2. Install Required Dependencies

```sh
npm i @tanstack/react-router @tanstack/react-start
npm i -D vite @vitejs/plugin-react @tailwindcss/vite tailwindcss vite-tsconfig-paths
```

#### 3. Update Project Configuration

**package.json:**
```json
{
  "type": "module",
  "scripts": {
    "dev": "vite dev",
    "build": "vite build",
    "start": "node .output/server/index.mjs"
  }
}
```

**vite.config.ts:**
```ts
import { defineConfig } from 'vite'
import { tanstackStart } from '@tanstack/react-start/plugin/vite'
import viteReact from '@vitejs/plugin-react'
import tsconfigPaths from 'vite-tsconfig-paths'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  server: {
    port: 3020, // Match d2c-trade-in port
  },
  plugins: [
    tailwindcss(),
    tsconfigPaths(),
    tanstackStart({
      srcDirectory: 'src',
      router: {
        routesDirectory: 'app', // Keep Next.js convention
      },
    }),
    viteReact(),
  ],
})
```

#### 4. Adapt the Root Layout

**From:** `src/app/layout.tsx`
**To:** `src/app/__root.tsx`

```tsx
import {
  Outlet,
  createRootRoute,
  HeadContent,
  Scripts,
} from "@tanstack/react-router"
import appCss from "./globals.css?url"

export const Route = createRootRoute({
  head: () => ({
    meta: [
      { charSet: "utf-8" },
      {
        name: "viewport",
        content: "width=device-width, initial-scale=1",
      },
      { title: "D2C Trade-In" }
    ],
    links: [
      {
        rel: 'stylesheet',
        href: appCss,
      },
    ],
  }),
  component: RootLayout,
})

function RootLayout() {
  return (
    <html lang="en">
      <head>
        <HeadContent />
      </head>
      <body>
        <Outlet />
        <Scripts />
      </body>
    </html>
  )
}
```

#### 5. Adapt Pages

**From:** `src/app/page.tsx`
**To:** `src/app/index.tsx`

```tsx
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/')({
  component: Home,
})

function Home() {
  return (
    // Your component JSX
  )
}
```

#### 6. Create Router Configuration

**Create:** `src/router.tsx`

```tsx
import { createRouter } from '@tanstack/react-router'
import { routeTree } from './routeTree.gen'

export function getRouter() {
  const router = createRouter({
    routeTree,
    scrollRestoration: true,
  })

  return router
}
```

## Routing Concepts

> 📖 **Deep Dive**: For a comprehensive guide on file-based routing patterns, directory vs flat routes, and route organization, see [File-Based Routing Structure](docs/router/file-based-routing-structure.md)

### Route Mapping Reference

| Route Example                  | Next.js                            | TanStack Start            |
| ------------------------------ | ---------------------------------- | ------------------------- |
| Root Layout                    | `src/app/layout.tsx`               | `src/app/__root.tsx`      |
| `/` (Home Page)                | `src/app/page.tsx`                 | `src/app/index.tsx`       |
| `/quote` (Static Route)        | `src/app/quote/page.tsx`           | `src/app/quote.tsx`       |
| `/quote/[id]` (Dynamic)        | `src/app/quote/[id]/page.tsx`      | `src/app/quote/$id.tsx`   |
| `/api/endpoint` (API Route)    | `src/app/api/endpoint/route.ts`    | `src/app/api/endpoint.ts` |

### Dynamic Routes

**Next.js:**
```tsx
export default async function Page({
  params,
}: {
  params: Promise<{ id: string }>
}) {
  const { id } = await params
  return <div>Quote: {id}</div>
}
```

**TanStack Start:**
```tsx
export const Route = createFileRoute('/quote/$id')({
  component: Page,
})

function Page() {
  const { id } = Route.useParams()
  return <div>Quote: {id}</div>
}
```

### Search Params

**TanStack Start:**
```tsx
const { page, filter, sort } = Route.useSearch()
```

### Links

> 📖 **Deep Dive**: For comprehensive navigation patterns including relative navigation, active states, preloading, and the useNavigate hook, see [Navigation](docs/router/navigation.md)

**Next.js:**
```tsx
import Link from "next/link"

function Component() {
  return <Link href="/quote">Get Quote</Link>
}
```

**TanStack Start:**
```tsx
import { Link } from "@tanstack/react-router"

function Component() {
  return <Link to="/quote">Get Quote</Link>
}
```

## Data Fetching

> 📖 **Deep Dive**: For comprehensive information on route loaders, caching strategies, SWR patterns, loaderDeps, search params, context, error handling, and more, see [Data Loading](docs/router/data-loading.md)

### Fetching Data in Loaders

**Next.js:**
```tsx
export default async function Page() {
  const data = await fetch('https://api.example.com/data')
  const items = await data.json()

  return (
    <ul>
      {items.map((item) => (
        <li key={item.id}>{item.title}</li>
      ))}
    </ul>
  )
}
```

**TanStack Start:**
```tsx
export const Route = createFileRoute('/')({
  component: Page,
  loader: async () => {
    const res = await fetch('https://api.example.com/data')
    return res.json()
  },
})

function Page() {
  const items = Route.useLoaderData()

  return (
    <ul>
      {items.map((item) => (
        <li key={item.id}>{item.title}</li>
      ))}
    </ul>
  )
}
```

## Server Functions

> 📖 **Deep Dive**: For comprehensive information on server functions including validation with Zod, form handling (FormData), error handling & redirects, streaming, middleware, and more, see [Server Functions](docs/start/server-functions.md)
>
> ⚠️ **Important**: Understanding the execution model is critical for secure applications. See [Execution Model](docs/start/execution-model.md) to learn about isomorphic-by-default behavior, server-only vs client-only patterns, and security considerations.

**Next.js Server Actions:**
```tsx
'use server'

export const create = async () => {
  return true
}
```

**TanStack Start:**
```tsx
import { createServerFn } from "@tanstack/react-start"

export const create = createServerFn().handler(async () => {
  return true
})
```

## Server Routes (API Handlers)

**Next.js:**
```ts
export async function GET() {
  return Response.json({ message: "Hello" })
}
```

**TanStack Start:**
```ts
export const Route = createFileRoute('/api/hello')({
  server: {
    handlers: {
      GET: async () => {
        return Response.json({ message: "Hello" })
      }
    }
  }
})
```

## Images

For optimized images, use [Unpic](https://unpic.pics/) as a drop-in replacement for `next/image`:

**Next.js:**
```tsx
import Image from 'next/image'

function Component() {
  return (
    <Image
      src="/path/to/image.jpg"
      alt="Description"
      width="600"
      height="400"
    />
  )
}
```

**TanStack Start:**
```tsx
import { Image } from '@unpic/react'

function Component() {
  return (
    <Image
      src="/path/to/image.jpg"
      alt="Description"
      width={600}
      height={400}
    />
  )
}
```

## Forms

> 📖 **Deep Dive**: For comprehensive form handling with TanStack Form including field state management, validation patterns, array fields, and reactivity, see [Basic Concepts](docs/forms/basic-concepts.md)

The d2c-trade-in app currently uses **React Hook Form**. As part of this migration, we&apos;re adopting **TanStack Form** (`@tanstack/react-form`), which integrates seamlessly with TanStack Router patterns and provides tight integration with the TanStack ecosystem.

### TanStack Form (Preferred Approach)

TanStack Form offers first-class integration with TanStack Router/Start:

```tsx
import { useForm } from '@tanstack/react-form'
import { zodValidator } from '@tanstack/zod-form-adapter'
import { z } from 'zod'

function ContactForm() {
  const form = useForm({
    defaultValues: {
      email: '',
      name: '',
    },
    validators: {
      onChange: z.object({
        email: z.string().email(),
        name: z.string().min(2),
      }),
    },
    onSubmit: async ({ value }) => {
      await submitContact(value)
    },
  })

  return (
    <form onSubmit={(e) => { e.preventDefault(); form.handleSubmit() }}>
      <form.Field
        name="email"
        children={(field) => (
          <div>
            <input
              value={field.state.value}
              onBlur={field.handleBlur}
              onChange={(e) => field.handleChange(e.target.value)}
            />
            {field.state.meta.errors && (
              <span>{field.state.meta.errors.join(', ')}</span>
            )}
          </div>
        )}
      />
      <form.Field
        name="name"
        children={(field) => (
          <div>
            <input
              value={field.state.value}
              onBlur={field.handleBlur}
              onChange={(e) => field.handleChange(e.target.value)}
            />
            {field.state.meta.errors && (
              <span>{field.state.meta.errors.join(', ')}</span>
            )}
          </div>
        )}
      />
      <button type="submit">Submit</button>
    </form>
  )
}
```

**Key Features:**
- Field-level validation with real-time feedback
- Built-in field state management (`isTouched`, `isDirty`, `isValidating`)
- Type-safe form values
- Array field support for dynamic lists
- Seamless Zod/Valibot integration
- Optimized re-renders with fine-grained reactivity

See [Basic Concepts](docs/forms/basic-concepts.md) for comprehensive TanStack Form documentation.

### Form Submission with Server Functions

TanStack Form integrates perfectly with server functions:

```tsx
import { createServerFn } from '@tanstack/react-start'
import { z } from 'zod'

const ContactSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2),
})

export const submitContact = createServerFn({ method: 'POST' })
  .inputValidator(ContactSchema)
  .handler(async ({ data }) => {
    // Server-only submission logic
    await db.contacts.create(data)
    return { success: true }
  })
```

See [Server Functions](docs/start/server-functions.md) for more on form submissions with TanStack Start.

## Fonts

Instead of `next/font`, use Tailwind CSS with Fontsource:

```sh
npm i -D @fontsource-variable/dm-sans @fontsource-variable/jetbrains-mono
```

**In `src/app/globals.css`:**
```css
@import 'tailwindcss';

@import '@fontsource-variable/dm-sans';
@import '@fontsource-variable/jetbrains-mono';

@theme inline {
  --font-sans: 'DM Sans Variable', sans-serif;
  --font-mono: 'JetBrains Mono Variable', monospace;
}
```

## Project Code Standards

When migrating, follow these project-specific standards from CLAUDE.md:

### Function Declarations
- Always use named function declarations: `function functionName() {}`
- Avoid arrow functions: `const functionName = () => {}`

### TypeScript Comments
- Use single-line comments (`//`) above properties
- Place comments directly above the property, not inline

### HTML Entities in JSX
- Use `&apos;` for apostrophes and single quotes
- Use `&quot;` for double quotes

### Conditional Rendering
- Prefer the content variable pattern over nested ternaries
- Use `let content: React.ReactNode = null` with if statements

### Class Names
- Always use `clsx` for merging class names
- Import `clsx` at the top of the file

**Example:**
```tsx
import clsx from 'clsx'

function Button({ isActive, size }: Props) {
  return (
    <button
      className={clsx(
        'rounded px-4 py-2',
        isActive && 'bg-blue-500 text-white',
        !isActive && 'bg-gray-200 text-gray-800',
        size === 'large' && 'text-lg',
      )}
    >
      Click me
    </button>
  )
}
```

## Migration Strategy

1. **Create New App Directory**: `apps/d2c-trade-in-tanstack/`
2. **Install Dependencies**: TanStack Start, Router, Vite plugins
3. **Configure Build**: Set up vite.config.ts with correct port (3020)
4. **Migrate Root Layout**: Convert layout.tsx to __root.tsx
5. **Migrate Routes**: Convert pages to TanStack Router file structure
6. **Update Data Fetching**: Convert to loader pattern
7. **Update Links**: Replace next/link with TanStack Router Link
8. **Update Server Actions**: Convert to server functions
9. **Update API Routes**: Convert to server route handlers
10. **Test**: Verify all routes and functionality work correctly

## Important Considerations

- **Preserve Business Logic**: Keep all API calls and business rules unchanged
- **Maintain Styling**: Radix UI components and Tailwind CSS remain the same
- **Forms**: Migrating from React Hook Form to **TanStack Form** for better integration with TanStack Router/Start. See [Basic Concepts](docs/forms/basic-concepts.md)
- **Monorepo Integration**: Ensure Turborepo configuration includes new app
- **Environment Variables**: Use `getEnv()` from common-nextjs package
  - ⚠️ **Security**: See [Execution Model - Security Considerations](docs/start/execution-model.md#security-considerations) for proper environment variable handling
- **Testing**: Update test configurations for Vite instead of Next.js
- **Execution Model**: Understand that route loaders are **isomorphic** (run on both server and client). Use server functions for server-only operations. See [Execution Model](docs/start/execution-model.md) for details.

## Quick Reference: Key Differences

### Router vs Start

- **TanStack Router**: The routing library (file-based routing, navigation, loaders)
- **TanStack Start**: Full-stack framework (includes Router + SSR + server functions)

### Route Loaders Are Isomorphic

```tsx
// ⚠️ This runs on BOTH server AND client
export const Route = createFileRoute('/users')({
  loader: () => {
    // Runs during SSR AND during client-side navigation
    return fetch('/api/users')
  },
})

// ✅ For server-only operations, use server functions
const getUsersSecurely = createServerFn().handler(() => {
  const secret = process.env.SECRET // Server-only
  return fetch(`/api/users?key=${secret}`)
})

export const Route = createFileRoute('/users')({
  loader: () => getUsersSecurely(), // Isomorphic call to server function
})
```

See [Execution Model](docs/start/execution-model.md) for critical details.

### Data Loading Patterns

```tsx
// Route loaders for page data
export const Route = createFileRoute('/posts')({
  loaderDeps: ({ search: { page } }) => ({ page }), // Dependencies
  loader: async ({ deps }) => fetchPosts(deps.page),
})

// Server functions for mutations and server-only operations
const createPost = createServerFn({ method: 'POST' })
  .inputValidator(PostSchema) // Zod validation
  .handler(async ({ data }) => db.posts.create(data))
```

See [Data Loading](docs/router/data-loading.md) and [Server Functions](docs/start/server-functions.md) for details.

### Navigation Patterns

```tsx
// Links with type-safe params and search
<Link
  to="/posts/$postId"
  params={{ postId: '123' }}
  search={{ page: 1 }}
>
  View Post
</Link>

// Imperative navigation
const navigate = useNavigate({ from: '/posts' })
navigate({ to: '/posts/$postId', params: { postId: '123' } })
```

See [Navigation](docs/router/navigation.md) for comprehensive patterns.

## Resources

### Official Documentation
- [TanStack Start Documentation](https://tanstack.com/start/latest)
- [TanStack Router Documentation](https://tanstack.com/router/latest)
- [Official Migration Guide](https://tanstack.com/router/latest/docs/framework/react/guide/migrate-from-next-js)

### Project-Specific Guides
- [File-Based Routing Structure](docs/router/file-based-routing-structure.md)
- [Data Loading](docs/router/data-loading.md)
- [Navigation](docs/router/navigation.md)
- [Server Functions](docs/start/server-functions.md)
- [Execution Model](docs/start/execution-model.md)
- [Forms - Basic Concepts](docs/forms/basic-concepts.md)