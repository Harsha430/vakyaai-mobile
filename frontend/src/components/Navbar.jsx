import React from 'react';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { motion, AnimatePresence } from 'framer-motion';
import { LogOut, LayoutDashboard, PlusCircle, User, Sparkles, X, Menu } from 'lucide-react';

const Navbar = () => {
    const { user, logout, isAuthenticated } = useAuth();
    const navigate = useNavigate();
    const location = useLocation();
    const [isMenuOpen, setIsMenuOpen] = React.useState(false);

    if (!isAuthenticated) return null;

    const navItems = [
        { name: 'Analyze', path: '/', icon: PlusCircle },
        { name: 'Library', path: '/dashboard', icon: LayoutDashboard },
    ];

    const toggleMenu = () => setIsMenuOpen(!isMenuOpen);

    return (
        <>
            <nav className="fixed top-4 md:top-6 left-1/2 -translate-x-1/2 z-[100] w-[95%] md:w-[90%] max-w-5xl">
                <div className="glass-card px-4 md:px-8 py-3 md:py-4 rounded-xl md:rounded-2xl border border-accent/20 backdrop-blur-md bg-white/5 flex items-center justify-between shadow-xl">
                    <Link to="/" className="flex items-center gap-2 group shrink-0">
                        <div className="p-1.5 md:p-2 bg-accent/20 rounded-lg group-hover:bg-accent/30 transition-colors">
                            <Sparkles className="w-4 h-4 md:w-5 md:h-5 text-accent" />
                        </div>
                        <span className="font-heading text-xl md:text-2xl text-parchment tracking-tight">Vākya AI</span>
                    </Link>

                    {/* Desktop Nav */}
                    <div className="hidden md:flex items-center gap-8">
                        {navItems.map((item) => (
                            <Link 
                                key={item.path}
                                to={item.path}
                                className={`flex items-center gap-2 font-medium transition-all hover:text-accent relative ${
                                    location.pathname === item.path ? 'text-accent' : 'text-parchment/60'
                                }`}
                            >
                                <item.icon className="w-4 h-4" />
                                <span>{item.name}</span>
                                {location.pathname === item.path && (
                                    <motion.div 
                                        layoutId="nav-underline"
                                        className="absolute -bottom-1 left-0 right-0 h-0.5 bg-accent rounded-full"
                                    />
                                )}
                            </Link>
                        ))}
                    </div>

                    <div className="flex items-center gap-2 md:gap-4 border-l border-accent/10 pl-4 md:pl-6 ml-1 md:ml-2">
                        <div className="flex items-center gap-2 md:gap-3 pr-1 md:pr-2">
                            <div className="w-7 h-7 md:w-8 md:h-8 rounded-full bg-accent/20 border border-accent/30 flex items-center justify-center text-accent font-bold text-xs shrink-0">
                                {user?.sub?.[0].toUpperCase() || 'U'}
                            </div>
                            <div className="hidden lg:block text-left text-xs">
                                <p className="text-parchment font-bold truncate max-w-[100px]">{user?.sub?.split('@')[0]}</p>
                                <p className="text-parchment/40">Manuscript Initiate</p>
                            </div>
                        </div>
                        
                        <div className="flex items-center gap-1">
                            <button 
                                onClick={() => {
                                    logout();
                                    navigate('/login');
                                }}
                                className="hidden md:block p-2 hover:bg-red-500/10 hover:text-red-400 text-parchment/40 rounded-lg transition-all"
                                title="Logout"
                            >
                                <LogOut className="w-5 h-5" />
                            </button>

                            {/* Mobile Menu Toggle */}
                            <button 
                                onClick={toggleMenu}
                                className="md:hidden p-2 text-parchment/60 hover:text-accent transition-colors"
                            >
                                {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
                            </button>
                        </div>
                    </div>
                </div>
            </nav>

            {/* Mobile Menu Overlay - Moved outside centered nav to prevent transform/clipping issues */}
            <AnimatePresence>
                {isMenuOpen && (
                    <div className="md:hidden">
                        {/* Backdrop */}
                        <motion.div 
                            initial={{ opacity: 0 }}
                            animate={{ opacity: 1 }}
                            exit={{ opacity: 0 }}
                            onClick={() => setIsMenuOpen(false)}
                            className="fixed inset-0 bg-primary/90 backdrop-blur-md z-[200]"
                        />
                        
                        {/* Drawer */}
                        <motion.div 
                            initial={{ x: '100%' }}
                            animate={{ x: 0 }}
                            exit={{ x: '100%' }}
                            transition={{ type: 'spring', damping: 25, stiffness: 200 }}
                            className="fixed top-0 right-0 bottom-0 w-[280px] z-[300] flex flex-col shadow-2xl"
                        >
                            {/* Force Solid Background */}
                            <div className="absolute inset-0 bg-primary border-l border-accent/20" style={{ backgroundColor: '#0F172A' }} />
                            
                            {/* Content Area */}
                            <div className="relative h-full p-6 flex flex-col">
                                <div className="flex items-center justify-between mb-8 pb-6 border-b border-accent/10">
                                    <div className="flex items-center gap-2">
                                        <Sparkles className="w-5 h-5 text-accent" />
                                        <span className="font-heading text-lg text-parchment">Vākya Menu</span>
                                    </div>
                                    <button 
                                        onClick={() => setIsMenuOpen(false)}
                                        className="p-2 text-parchment/40 hover:text-accent transition-colors"
                                    >
                                        <X className="w-6 h-6" />
                                    </button>
                                </div>

                                <div className="flex flex-col gap-2">
                                    {navItems.map((item) => (
                                        <Link 
                                            key={item.path}
                                            to={item.path}
                                            onClick={() => setIsMenuOpen(false)}
                                            className={`flex items-center gap-4 p-4 rounded-xl transition-all ${
                                                location.pathname === item.path 
                                                ? 'bg-accent/10 text-accent border border-accent/20' 
                                                : 'text-parchment/60 hover:bg-white/5 border border-transparent'
                                            }`}
                                        >
                                            <item.icon className="w-5 h-5" />
                                            <span className="font-bold uppercase tracking-widest text-xs">{item.name}</span>
                                        </Link>
                                    ))}
                                </div>

                                <div className="mt-auto space-y-4">
                                    <div className="p-4 rounded-xl bg-white/5 border border-white/5 flex items-center gap-3">
                                        <div className="w-10 h-10 rounded-full bg-accent/20 border border-accent/30 flex items-center justify-center text-accent font-bold">
                                            {user?.sub?.[0].toUpperCase() || 'U'}
                                        </div>
                                        <div className="min-w-0">
                                            <p className="text-parchment font-bold text-sm truncate">{user?.sub?.split('@')[0]}</p>
                                            <p className="text-parchment/40 text-[10px] uppercase tracking-wider">Manuscript Initiate</p>
                                        </div>
                                    </div>

                                    <button 
                                        onClick={() => {
                                            logout();
                                            navigate('/login');
                                        }}
                                        className="w-full flex items-center gap-4 p-4 text-red-400/60 rounded-xl hover:bg-red-400/10 transition-all border border-transparent"
                                    >
                                        <LogOut className="w-5 h-5" />
                                        <span className="font-bold uppercase tracking-widest text-xs">Sign Out</span>
                                    </button>
                                </div>
                            </div>
                        </motion.div>
                    </div>
                )}
            </AnimatePresence>
        </>
    );
};

export default Navbar;
