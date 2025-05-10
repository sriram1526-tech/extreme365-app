import React, { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { initializeApp } from "firebase/app";
import {
  getAuth,
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  signOut,
  onAuthStateChanged
} from "firebase/auth";

// Firebase config
const firebaseConfig = {
  apiKey: "AIzaSyAig14NSR7Tov1Awmooa5FfduIhITxyvjo",
  authDomain: "extreme365-55b91.firebaseapp.com",
  projectId: "extreme365-55b91",
  storageBucket: "extreme365-55b91.firebasestorage.app",
  messagingSenderId: "181183678665",
  appId: "1:181183678665:web:0cf4bc4f173f619299e518",
  measurementId: "G-20DPSD2P79"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

function LoginForm({ switchToSignup }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState(null);

  const handleLogin = async () => {
    try {
      await signInWithEmailAndPassword(auth, email, password);
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="p-6 bg-white text-black rounded-xl shadow-lg max-w-sm mx-auto mt-10">
      <h2 className="text-2xl font-bold mb-4 text-center">Login to Extreme365</h2>
      <input type="email" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} className="w-full mb-3 p-2 border rounded" />
      <input type="password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} className="w-full mb-4 p-2 border rounded" />
      {error && <p className="text-red-600 text-sm mb-2">{error}</p>}
      <Button onClick={handleLogin} className="w-full bg-blue-700 text-white">Login</Button>
      <p className="mt-4 text-center text-sm">
        Don't have an account? <button className="text-blue-500" onClick={switchToSignup}>Sign up</button>
      </p>
    </div>
  );
}

function SignupForm({ switchToLogin }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState(null);

  const handleSignup = async () => {
    try {
      await createUserWithEmailAndPassword(auth, email, password);
      switchToLogin();
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="p-6 bg-white text-black rounded-xl shadow-lg max-w-sm mx-auto mt-10">
      <h2 className="text-2xl font-bold mb-4 text-center">Sign up for Extreme365</h2>
      <input type="email" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} className="w-full mb-3 p-2 border rounded" />
      <input type="password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} className="w-full mb-4 p-2 border rounded" />
      {error && <p className="text-red-600 text-sm mb-2">{error}</p>}
      <Button onClick={handleSignup} className="w-full bg-purple-700 text-white">Sign Up</Button>
      <p className="mt-4 text-center text-sm">
        Already have an account? <button className="text-purple-500" onClick={switchToLogin}>Login</button>
      </p>
    </div>
  );
}

function Dashboard() {
  return (
    <div className="p-10 text-center">
      <h2 className="text-4xl font-bold mb-4">Welcome to Your Dashboard</h2>
      <p className="text-lg">This is a protected area only visible to logged-in users.</p>
    </div>
  );
}

export default function Extreme365Home() {
  const [form, setForm] = useState("home");
  const [user, setUser] = useState(null);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);

      // Redirect logic
      if (currentUser && (form === "login" || form === "signup")) {
        setForm("dashboard");
      }
    });
    return () => unsubscribe();
  }, [form]);

  const handleLogout = async () => {
    await signOut(auth);
    setForm("home");
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 text-white font-sans">
      {/* Header */}
      <header className="flex justify-between items-center p-6 bg-black bg-opacity-50 shadow-md">
        <h1 className="text-3xl font-bold">Extreme365</h1>
        <nav className="space-x-6">
          <button onClick={() => setForm("home")} className="hover:text-yellow-300">Home</button>
          {user && <button onClick={() => setForm("dashboard")} className="hover:text-yellow-300">Dashboard</button>}
          {!user ? (
            <>
              <button onClick={() => setForm("login")} className="hover:text-yellow-300">Login</button>
              <button onClick={() => setForm("signup")} className="hover:text-yellow-300">Sign Up</button>
            </>
          ) : (
            <>
              <span className="text-sm">Welcome, {user.email}</span>
              <button onClick={handleLogout} className="hover:text-red-400">Logout</button>
            </>
          )}
        </nav>
      </header>

      {form === "home" && (
        <>
          <section className="text-center py-20 px-6">
            <h2 className="text-4xl md:text-6xl font-bold mb-4">Your Ultimate Betting Experience</h2>
            <p className="text-lg md:text-xl mb-8">Play sports, casino, and more — all in one place</p>
            <Button onClick={() => setForm("signup")} className="bg-yellow-400 text-black font-bold px-6 py-3 text-lg rounded-full">Join Now</Button>
          </section>

          <section className="px-6 py-12 grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              { name: "Cricket", color: "bg-green-500" },
              { name: "Casino", color: "bg-red-500" },
              { name: "Slots", color: "bg-yellow-500" },
            ].map((game) => (
              <div key={game.name} className={`p-6 rounded-xl shadow-xl ${game.color} text-black text-center text-2xl font-semibold`}>
                {game.name}
              </div>
            ))}
          </section>
        </>
      )}

      {form === "login" && !user && <LoginForm switchToSignup={() => setForm("signup")} />}
      {form === "signup" && !user && <SignupForm switchToLogin={() => setForm("login")} />}
      {form === "dashboard" && user && <Dashboard />}

      <footer className="text-center py-6 bg-black bg-opacity-50 text-sm mt-12">
        © 2025 Extreme365. All rights reserved.
      </footer>
    </div>
  );
}
