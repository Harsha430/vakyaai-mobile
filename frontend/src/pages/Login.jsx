import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { useAuth } from '../context/AuthContext';
import { loginUser } from '../services/api';
import { Link, useNavigate } from 'react-router-dom';
import { LogIn, Mail, Lock, ShieldCheck, Sparkles } from 'lucide-react';

const Login = () => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState('');
    const { login } = useAuth();
    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();
        setIsLoading(true);
        setError('');
        try {
            const data = await loginUser({ email, password });
            login(data.access_token);
            navigate('/dashboard');
        } catch (err) {
            const detail = err.response?.data?.detail;
            if (Array.isArray(detail)) {
                setError(detail[0]?.msg || 'Validation failed');
            } else if (typeof detail === 'string') {
                setError(detail);
            } else {
                setError('Invalid email or password');
            }
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <div className="min-h-screen flex items-center justify-center p-6 bg-primary font-body relative overflow-hidden">
            {/* Background Decorative Elements */}
            <div className="absolute top-0 left-0 w-full h-full opacity-10 pointer-events-none">
                <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-accent blur-[120px] rounded-full"></div>
                <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-accent-light blur-[120px] rounded-full opacity-50"></div>
            </div>

            <motion.div 
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                className="w-full max-w-md relative z-10"
            >
                <div className="glass-card p-10 rounded-3xl border border-accent/20 backdrop-blur-xl bg-white/5 shadow-2xl relative overflow-hidden group">
                    {/* Animated Border Glow */}
                    <div className="absolute inset-0 bg-gradient-to-r from-accent/0 via-accent/10 to-accent/0 opacity-0 group-hover:opacity-100 transition-opacity duration-1000 -translate-x-full group-hover:translate-x-full ease-in-out"></div>
                    
                    <div className="text-center mb-10">
                        <motion.div 
                            animate={{ rotate: [0, 10, -10, 0] }}
                            transition={{ duration: 4, repeat: Infinity }}
                            className="inline-block p-4 bg-accent/10 rounded-2xl mb-4 border border-accent/20"
                        >
                            <ShieldCheck className="w-10 h-10 text-accent" />
                        </motion.div>
                        <h1 className="text-4xl font-heading text-parchment mb-2 tracking-tight">Vākya Auth</h1>
                        <p className="text-parchment/60 font-medium">Enter the digital manuscript sanctum</p>
                    </div>

                    <form onSubmit={handleSubmit} className="space-y-6">
                        <div className="space-y-4">
                            <div className="relative group">
                                <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-accent/50 group-focus-within:text-accent transition-colors" />
                                <input 
                                    type="email" 
                                    required
                                    placeholder="your@email.com"
                                    className="w-full bg-primary-light/30 border border-accent/10 rounded-xl py-4 pl-12 pr-4 text-parchment placeholder:text-parchment/20 focus:outline-none focus:border-accent/40 focus:ring-1 focus:ring-accent/40 transition-all font-medium"
                                    value={email}
                                    onChange={(e) => setEmail(e.target.value)}
                                />
                            </div>
                            <div className="relative group">
                                <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-accent/50 group-focus-within:text-accent transition-colors" />
                                <input 
                                    type="password" 
                                    required
                                    placeholder="••••••••"
                                    className="w-full bg-primary-light/30 border border-accent/10 rounded-xl py-4 pl-12 pr-4 text-parchment placeholder:text-parchment/20 focus:outline-none focus:border-accent/40 focus:ring-1 focus:ring-accent/40 transition-all font-medium"
                                    value={password}
                                    onChange={(e) => setPassword(e.target.value)}
                                />
                            </div>
                        </div>

                        {error && (
                            <motion.div 
                                initial={{ opacity: 0, x: -10 }}
                                animate={{ opacity: 1, x: 0 }}
                                className="p-3 bg-red-500/10 border border-red-500/20 text-red-500 rounded-lg text-sm text-center font-medium"
                            >
                                {error}
                            </motion.div>
                        )}

                        <button 
                            type="submit"
                            disabled={isLoading}
                            className="w-full relative overflow-hidden bg-accent hover:bg-accent-light text-primary font-bold py-4 rounded-xl transition-all shadow-lg shadow-accent/20 active:scale-[0.98] group flex items-center justify-center gap-2"
                        >
                            {isLoading ? (
                                <div className="w-5 h-5 border-2 border-primary/30 border-t-primary rounded-full animate-spin"></div>
                            ) : (
                                <>
                                    <span>Login to Vākya</span>
                                    <LogIn className="w-5 h-5 transition-transform group-hover:translate-x-1" />
                                </>
                            )}
                        </button>
                    </form>

                    <div className="mt-10 text-center space-y-4">
                        <p className="text-parchment/40 text-sm font-medium">
                            No access key? {' '}
                            <Link to="/register" className="text-accent hover:text-accent-light transition-colors underline underline-offset-4 decoration-accent/30 hover:decoration-accent-light">
                                Authenticate Here
                            </Link>
                        </p>
                    </div>
                </div>
            </motion.div>
        </div>
    );
};

export default Login;
