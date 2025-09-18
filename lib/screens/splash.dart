
import 'package:flutter/material.dart';
import 'funcionalidade/lista.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _carregando = false;
      });
    });
  }

  void _irParaEventos() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ListaEventos()),
    );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo personalizado
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.shade200],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(Icons.celebration, size: 70, color: Colors.blue.shade700),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Meu Rolê',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Eventos Culturais, Esportivos e Educacionais',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 32),
            _carregando
                ? Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Carregando...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  )
                : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: _irParaEventos,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Ver eventos'),
                  ),
          ],
        ),
      ),
    );
  }
}
