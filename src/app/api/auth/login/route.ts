import { NextRequest, NextResponse } from 'next/server';
import { auth } from '@/lib/auth/better-auth';
import { syncUserProfile, getUserProfile } from '@/lib/services/supabase-service';

export async function POST(request: NextRequest) {
  try {
    const { email, password } = await request.json();

    if (!email || !password) {
      return NextResponse.json(
        { error: 'Email and password are required' },
        { status: 400 }
      );
    }

    // Sign in with Better Auth - this handles cookie setting internally
    const signInResult = await auth.api.signInEmail({
      body: { email, password },
      headers: request.headers as any,
    });

    if (!signInResult || signInResult.error) {
      return NextResponse.json(
        { error: signInResult?.error?.message || 'Invalid email or password' },
        { status: 401 }
      );
    }

    if (!signInResult.user) {
      return NextResponse.json(
        { error: 'Sign in succeeded but no user was returned' },
        { status: 500 }
      );
    }

    // Ensure user profile exists in Supabase
    try {
      await syncUserProfile(signInResult.user.id, signInResult.user.email || email);
    } catch (error) {
      console.error('Error syncing user profile:', error);
      // Don't fail the sign-in if profile sync fails
    }

    // Get user profile to check admin status
    const profile = await getUserProfile(signInResult.user.id);

    if (!profile) {
      return NextResponse.json(
        { error: 'User profile not found. Please contact your administrator.' },
        { status: 403 }
      );
    }

    const isAdmin = profile.is_admin === true;

    if (!isAdmin) {
      return NextResponse.json(
        { error: 'User is not an admin. Please contact your administrator to grant admin access.' },
        { status: 403 }
      );
    }

    // Create response with user data
    const responseData = {
      user: {
        id: signInResult.user.id,
        email: signInResult.user.email,
        isAdmin: true,
      },
    };

    // Build response and forward ALL set-cookie headers from Better Auth
    const response = NextResponse.json(responseData);

    if (signInResult?.headers) {
      const headers = signInResult.headers as any;

      // Prefer getSetCookie (available in Next.js Headers)
      if (typeof headers.getSetCookie === 'function') {
        const cookies: string[] = headers.getSetCookie();
        cookies.forEach((cookie: string) => {
          response.headers.append('set-cookie', cookie);
        });
      } else if (typeof headers.get === 'function') {
        const setCookieHeader = headers.get('set-cookie');
        if (setCookieHeader) {
          response.headers.append('set-cookie', setCookieHeader);
        }
      }
    }

    return response;
  } catch (error: any) {
    console.error('Sign-in error:', error);
    return NextResponse.json(
      { error: error.message || 'An unexpected error occurred' },
      { status: 500 }
    );
  }
}


