import NextAuth from "next-auth"
import Credentials from "next-auth/providers/credentials"
import { z } from "zod"

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
})

export const { handlers, signIn, signOut, auth } = NextAuth({
  providers: [
    Credentials({
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" },
      },
      async authorize(credentials) {
        try {
          const { email, password } = loginSchema.parse(credentials)
          
          // Demo authentication - replace with your actual auth logic
          if (email === "admin@energytracker.com" && password === "password123") {
            return {
              id: "1",
              email: "admin@energytracker.com",
              name: "Energy Tracker Admin",
              role: "admin",
            }
          }
          
          if (email === "user@energytracker.com" && password === "password123") {
            return {
              id: "2",
              email: "user@energytracker.com",
              name: "Energy Tracker User",
              role: "user",
            }
          }
          
          return null
        } catch (error) {
          return null
        }
      },
    }),
  ],
  pages: {
    signIn: "/login",
  },
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.role = user.role
      }
      return token
    },
    async session({ session, token }) {
      if (token) {
        session.user.id = token.sub!
        session.user.role = token.role as string
      }
      return session
    },
  },
  session: {
    strategy: "jwt",
  },
})
