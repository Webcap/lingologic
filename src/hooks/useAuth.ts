import { useState, useEffect, useRef } from 'react';
import { useRouter } from 'next/navigation';
import { AdminUser } from '@/lib/auth/client';
import { getClientUser, onAuthStateChange } from '@/lib/auth/client';

export function useAuth() {
  const [user, setUser] = useState<AdminUser | null>(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();
  const isMountedRef = useRef(true);
  const isLoggingInRef = useRef(false);

  useEffect(() => {
    isMountedRef.current = true;
    let isInitializing = true;

    const initAuth = async () => {
      try {
        // Fetch user from API route which uses server-side auth
        const response = await fetch('/api/auth/user');
        const data = await response.json();
        
        if (isMountedRef.current) {
          setUser(data.user);
          isInitializing = false;
          setLoading(false);
        }
      } catch (error) {
        console.error('Error initializing auth:', error);
        if (isMountedRef.current) {
          setUser(null);
          isInitializing = false;
          setLoading(false);
        }
      }
    };

    // Initialize auth
    initAuth();

    // Safety timeout
    const safetyTimeout = setTimeout(() => {
      if (isMountedRef.current && isInitializing) {
        console.warn('Auth initialization timeout - setting loading to false');
        isInitializing = false;
        setLoading(false);
      }
    }, 5000); // 5 second timeout

    // Listen for auth state changes
    const { data: { subscription } } = onAuthStateChange((authUser) => {
      if (isMountedRef.current && !isLoggingInRef.current) {
        setUser(authUser);
        if (!isInitializing) {
          setLoading(false);
        }
      }
    });

    return () => {
      isMountedRef.current = false;
      clearTimeout(safetyTimeout);
      subscription.unsubscribe();
    };
  }, []);

  const login = async (email: string, password: string) => {
    setLoading(true);
    isLoggingInRef.current = true;
    
    try {
      // Use Better Auth built-in sign-in endpoint so cookies are set correctly
      const signInRes = await fetch('/api/auth/sign-in/email', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      });

      const signInJson = await signInRes.json();
      console.log('Better Auth sign-in response:', { ok: signInRes.ok, status: signInRes.status, signInJson });

      if (!signInRes.ok) {
        throw new Error(signInJson?.error || 'Failed to sign in');
      }

      // After sign-in, fetch the user (includes admin flag)
      const userRes = await fetch('/api/auth/user');
      const userJson = await userRes.json();

      if (!userJson?.user || !userJson.user.isAdmin) {
        throw new Error('User is not an admin or session not established');
      }

      console.log('Setting user state:', userJson.user);
      setUser(userJson.user);
      
      // Refresh the router to update server-side state
      router.refresh();
      
      return userJson.user;
    } catch (error: any) {
      console.error('Login error:', error);
      setUser(null);
      throw error;
    } finally {
      isLoggingInRef.current = false;
      setLoading(false);
    }
  };

  const logout = async () => {
    try {
      await fetch('/api/auth/logout', {
        method: 'POST',
      });
      
      setUser(null);
      router.push('/login');
      router.refresh();
    } catch (error) {
      console.error('Logout error:', error);
      // Still clear user state even if logout request fails
      setUser(null);
      router.push('/login');
    }
  };

  return {
    user,
    loading,
    login,
    logout,
    isAuthenticated: !!user,
    isAdmin: user?.isAdmin || false,
  };
}



