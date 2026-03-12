import axios from 'axios';

const getApiUrl = () => {
    let url = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000';
    // Remove trailing slash if present
    url = url.replace(/\/$/, '');
    // Append /api if not present
    if (!url.endsWith('/api')) {
        url += '/api';
    }
    return url;
};

const API_URL = getApiUrl();

const api = axios.create({
    baseURL: API_URL,
    timeout: 60000,
    headers: {
        'Content-Type': 'application/json',
    },
});

// Add token to requests
api.interceptors.request.use((config) => {
    const token = localStorage.getItem('vakyaToken');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

// Auth Endpoints
export const loginUser = async (credentials) => {
    const response = await api.post('/auth/login', credentials);
    return response.data;
};

export const registerUser = async (userData) => {
    const response = await api.post('/auth/register', userData);
    return response.data;
};

export const getMe = async () => {
    const response = await api.get('/user/me');
    return response.data;
};

// Pitch Endpoints
export const analyzePitch = async (pitchText, targetAudience = "General Investor") => {
    const response = await api.post('/analyze', { 
        pitch_text: pitchText,
        target_audience: targetAudience
    });
    return response.data;
};

export const getMyAnalyses = async () => {
    const response = await api.get('/my-analyses');
    return response.data;
};

export default api;
