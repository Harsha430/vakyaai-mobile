import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { useAuth } from '../context/AuthContext';
import { registerUser } from '../services/api';
import { Link, useNavigate } from 'react-router-dom';
import { UserPlus, Mail, Lock, User, Briefcase, Sparkles, Wand2 } from 'lucide-react';

const Register = () => {
    const [formData, setFormData] = useState({
        full_name: '',
        email: '',
        job_role: '',
        password: ''
    });
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState('');
    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();
        setIsLoading(true);
        setError('');
        try {
            await registerUser(formData);
            navigate('/login');
        } catch (err) {
            const detail = err.response?.data?.detail;
            if (Array.isArray(detail)) {
                // Handle Pydantic validation errors
                setError(detail[0]?.msg || 'Validation failed');
            } else if (typeof detail === 'string') {
                setError(detail);
            } else {
                setError('Registration failed. Please try again.');
            }
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <div className="min-h-screen flex items-center justify-center p-6 bg-primary font-body relative overflow-hidden">
            {/* Background Decorative Elements */}
            <div className="absolute top-0 right-0 w-full h-full opacity-10 pointer-events-none">
                <div className="absolute top-[-10%] right-[-10%] w-[40%] h-[40%] bg-accent blur-[120px] rounded-full"></div>
                <div className="absolute bottom-[-10%] left-[-10%] w-[40%] h-[40%] bg-accent-light blur-[120px] rounded-full opacity-50"></div>
            </div>

            <motion.div 
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                className="w-full max-w-lg relative z-10"
            >
                <div className="glass-card p-10 rounded-3xl border border-accent/20 backdrop-blur-xl bg-white/5 shadow-2xl relative overflow-hidden group">
                    <div className="text-center mb-8">
                        <motion.div 
                            animate={{ scale: [1, 1.1, 1] }}
                            transition={{ duration: 3, repeat: Infinity }}
                            className="inline-block p-4 bg-accent/10 rounded-2xl mb-4 border border-accent/20"
                        >
                            <UserPlus className="w-10 h-10 text-accent" />
                        </motion.div>
                        <h1 className="text-4xl font-heading text-parchment mb-2 tracking-tight">Create Identity</h1>
                        <p className="text-parchment/60 font-medium">Join the circle of Vākya pitch masters</p>
                    </div>

                    <form onSubmit={handleSubmit} className="space-y-4">
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div className="relative group col-span-1 md:col-span-2">
                                <User className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-accent/50 group-focus-within:text-accent transition-colors" />
                                <input 
                                    type="text" 
                                    required
                                    placeholder="Full Name"
                                    className="w-full bg-primary-light/30 border border-accent/10 rounded-xl py-4 pl-12 pr-4 text-parchment placeholder:text-parchment/20 focus:outline-none focus:border-accent/40 focus:ring-1 focus:ring-accent/40 transition-all font-medium"
                                    value={formData.full_name}
                                    onChange={(e) => setFormData({...formData, full_name: e.target.value})}
                                />
                            </div>
                            <div className="relative group">
                                <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-accent/50 group-focus-within:text-accent transition-colors" />
                                <input 
                                    type="email" 
                                    required
                                    placeholder="Email Address"
                                    className="w-full bg-primary-light/30 border border-accent/10 rounded-xl py-4 pl-12 pr-4 text-parchment placeholder:text-parchment/20 focus:outline-none focus:border-accent/40 focus:ring-1 focus:ring-accent/40 transition-all font-medium"
                                    value={formData.email}
                                    onChange={(e) => setFormData({...formData, email: e.target.value})}
                                />
                            </div>
                            <div className="relative group">
                                <Briefcase className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-accent/50 group-focus-within:text-accent transition-colors" />
                                <select 
                                    className="w-full bg-primary-light/30 border border-accent/10 rounded-xl py-4 pl-12 pr-4 text-parchment focus:outline-none focus:border-accent/40 focus:ring-1 focus:ring-accent/40 transition-all font-medium appearance-none"
                                    value={formData.job_role}
                                    onChange={(e) => setFormData({...formData, job_role: e.target.value})}
                                >
                                    <option value="" disabled className="bg-primary">Select Role</option>
                                    <option value="Founder" className="bg-primary">Founder</option>
                                    <option value="Student" className="bg-primary">Student</option>
                                    <option value="Developer" className="bg-primary">Developer</option>
                                    <option value="Executive" className="bg-primary">Executive</option>
                                </select>
                            </div>
                            <div className="relative group col-span-1 md:col-span-2">
                                <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-accent/50 group-focus-within:text-accent transition-colors" />
                                <input 
                                    type="password" 
                                    required
                                    placeholder="Create Strong Password (min. 8 chars)"
                                    className="w-full bg-primary-light/30 border border-accent/10 rounded-xl py-4 pl-12 pr-4 text-parchment placeholder:text-parchment/20 focus:outline-none focus:border-accent/40 focus:ring-1 focus:ring-accent/40 transition-all font-medium"
                                    value={formData.password}
                                    onChange={(e) => setFormData({...formData, password: e.target.value})}
                                />
                            </div>
                        </div>

                        {error && (
                            <motion.div 
                                initial={{ opacity: 0 }}
                                animate={{ opacity: 1 }}
                                className="p-3 bg-red-500/10 border border-red-500/20 text-red-500 rounded-lg text-sm text-center font-medium"
                            >
                                {error}
                            </motion.div>
                        )}

                        <button 
                            type="submit"
                            disabled={isLoading}
                            className="w-full relative overflow-hidden bg-accent hover:bg-accent-light text-primary font-bold py-4 rounded-xl transition-all shadow-lg shadow-accent/20 active:scale-[0.98] group flex items-center justify-center gap-2 mt-4"
                        >
                            {isLoading ? (
                                <div className="w-5 h-5 border-2 border-primary/30 border-t-primary rounded-full animate-spin"></div>
                            ) : (
                                <>
                                    <span>Begin Your Journey</span>
                                    <Wand2 className="w-5 h-5 transition-transform group-hover:rotate-12" />
                                </>
                            )}
                        </button>
                    </form>

                    <div className="mt-8 text-center">
                        <p className="text-parchment/40 text-sm font-medium">
                            Already an initiate? {' '}
                            <Link to="/login" className="text-accent hover:text-accent-light transition-colors underline underline-offset-4 decoration-accent/30 hover:decoration-accent-light">
                                Sign In
                            </Link>
                        </p>
                    </div>
                </div>
            </motion.div>
        </div>
    );
};

export default Register;
