import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // 1. Configuración de la animación (Duración: 2.5 segundos)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Efecto de aparición (Fade)
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    // Efecto de escala (Zoom suave)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Iniciar animación
    _controller.forward();

    // 2. Navegar al Dashboard automáticamente al terminar
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Esperamos 3 segundos en total para que se vea el logo
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      // Usamos .go para que NO se pueda volver atrás al Splash
      context.go('/dashboard'); 
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos el color de fondo de tu tema
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO ANIMADO
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Container(
                  width: 150, // Tamaño del logo
                  height: 150,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, // Fondo blanco para el logo
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Image.asset('assets/logo.png'), 
                ),
              ),
            ),
            
            const SizedBox(height: 50),
            
            // TEXTO DE CARGA + INDICADOR
            FadeTransition(
              opacity: _opacityAnimation,
              child: Column(
                children: [
                  SizedBox(
                    width: 30, 
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      // Color del indicador según tu tema
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Iniciando Inventario 360...",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}