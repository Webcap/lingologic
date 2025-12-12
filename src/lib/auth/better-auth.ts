import 'server-only';
import { betterAuth } from 'better-auth';
import { Pool } from 'pg';

// Better Auth configuration
// Uses Supabase PostgreSQL database for Better Auth tables
const databaseUrl = process.env.DATABASE_URL;

if (!databaseUrl) {
  throw new Error('DATABASE_URL environment variable is required');
}

// Create PostgreSQL connection pool with proper configuration
const pool = new Pool({
  connectionString: databaseUrl,
  ssl: databaseUrl.includes('supabase') ? { rejectUnauthorized: false } : undefined,
  // Pool configuration for Supabase
  max: 10, // Maximum number of clients in the pool
  idleTimeoutMillis: 30000, // Close idle clients after 30 seconds
  connectionTimeoutMillis: 10000, // Return an error after 10 seconds if connection could not be established
  // Allow the pool to create new connections as needed
  allowExitOnIdle: false,
});

// Handle pool errors gracefully to prevent uncaught exceptions
pool.on('error', (err) => {
  // Log connection pool errors but don't crash the app
  if (err.message.includes('shutdown') || err.message.includes('termination')) {
    // Expected when connections are closed/terminated
    console.warn('Database connection pool error (handled):', err.message);
  } else {
    console.error('Database connection pool error:', err);
  }
});

// Handle client errors
pool.on('connect', (client) => {
  client.on('error', (err) => {
    if (err.message.includes('shutdown') || err.message.includes('termination')) {
      console.warn('Database client error (handled):', err.message);
    } else {
      console.error('Database client error:', err);
    }
  });
});

export const auth = betterAuth({
  baseURL: process.env.BETTER_AUTH_URL || process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000',
  basePath: '/api/auth',
  database: pool,
  emailAndPassword: {
    enabled: true,
    requireEmailVerification: false, // Set to true in production
  },
  session: {
    expiresIn: 60 * 60 * 24 * 7, // 7 days
    updateAge: 60 * 60 * 24, // 1 day
    cookie: {
      sameSite: 'lax',
      secure: process.env.NODE_ENV === 'production',
      path: '/',
    },
  },
  trustedOrigins: [
    process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000',
    'http://localhost:*', // For Flutter development
    'https://*.supabase.co', // For Supabase
  ],
});

export type Session = typeof auth.$Infer.Session;

import 'server-only';
import { betterAuth } from 'better-auth';
import { Pool } from 'pg';

// Better Auth configuration
// Uses Supabase PostgreSQL database for Better Auth tables
const databaseUrl = process.env.DATABASE_URL;

if (!databaseUrl) {
  throw new Error('DATABASE_URL environment variable is required');
}

// Create PostgreSQL connection pool with proper configuration
const pool = new Pool({
  connectionString: databaseUrl,
  ssl: databaseUrl.includes('supabase') ? { rejectUnauthorized: false } : undefined,
  // Pool configuration for Supabase
  max: 10, // Maximum number of clients in the pool
  idleTimeoutMillis: 30000, // Close idle clients after 30 seconds
  connectionTimeoutMillis: 10000, // Return an error after 10 seconds if connection could not be established
  // Allow the pool to create new connections as needed
  allowExitOnIdle: false,
});

// Handle pool errors gracefully to prevent uncaught exceptions
pool.on('error', (err) => {
  if (err.message.includes('shutdown') || err.message.includes('termination')) {
    console.warn('Database connection pool error (handled):', err.message);
  } else {
    console.error('Database connection pool error:', err);
  }
});

// Handle client errors
pool.on('connect', (client) => {
  client.on('error', (err) => {
    if (err.message.includes('shutdown') || err.message.includes('termination')) {
      console.warn('Database client error (handled):', err.message);
    } else {
      console.error('Database client error:', err);
    }
  });
});

export const auth = betterAuth({
  baseURL: process.env.BETTER_AUTH_URL || process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000',
  basePath: '/api/auth',
  database: pool,
  emailAndPassword: {
    enabled: true,
    requireEmailVerification: false, // Set to true in production
  },
  session: {
    expiresIn: 60 * 60 * 24 * 7, // 7 days
    updateAge: 60 * 60 * 24, // 1 day
    cookie: {
      sameSite: 'lax',
      secure: process.env.NODE_ENV === 'production',
      path: '/',
    },
  },
  trustedOrigins: [
    process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000',
    'http://localhost:*', // For Flutter development
    'https://*.supabase.co', // For Supabase
  ],
});

export type Session = typeof auth.$Infer.Session;


