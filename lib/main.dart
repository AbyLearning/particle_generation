import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ParticleWidget(),
    );
  }
}

class ParticleWidget extends StatefulWidget {
  const ParticleWidget();

  @override
  _ParticleWidgetState createState() => _ParticleWidgetState();
}

class _ParticleWidgetState extends State<ParticleWidget>
    with SingleTickerProviderStateMixin {
  late List<Particle> particles;

  // Random rd = Random(DateTime.now().millisecondsSinceEpoch);
  Random rd = Random();
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          // controller.forward();
        }
      });
    controller.forward();

    particles = List<Particle>.generate(100, (index) {
      var particle = Particle();
      particle.position = Offset(-1, -1);
      particle.radius = doubleInRange(rd, 2, 20);
      particle.speed = doubleInRange(rd, .03, 2.0);
      particle.angle = rd.nextDouble() * 2 * pi;
      particle.color = getRandomColor(rd);
      return particle;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: ParticlePainter(particles, rd),
      ),
    );
  }
}

Offset getVelocity(double angle, double speed) {
  var dx = speed * cos(angle);
  var dy = speed * sin(angle);
  return Offset(dx, dy);
}

Color getRandomColor(Random random) {
  int red = intInRange(random, 100, 255);
  int green = intInRange(random, 0, 255);
  int blue = intInRange(random, 0, 255);
  int alpha = intInRange(random, 210, 255);
  return Color.fromARGB(alpha, red, green, blue);
}

double doubleInRange(Random random, num min, num max) =>
    random.nextDouble() * (max - min) + min;

int intInRange(Random random, int min, int max) =>
    min + random.nextInt(max - min);

class ParticlePainter extends CustomPainter {
  List<Particle> particles;
  Random random;

  ParticlePainter(this.particles, this.random);

  Paint circlePaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    particles.forEach((particle) {
      var velocity = getVelocity(particle.angle, particle.speed);
      var dx = particle.position.dx + velocity.dx;
      var dy = particle.position.dy + velocity.dy;

      if (dx < 0 || dx > size.width) {
        dx = random.nextDouble() * size.width;
      }
      if (dy < 0 || dy > size.height) {
        dy = random.nextDouble() * size.height;
      }

      particle.position = Offset(dx, dy);
      circlePaint.color = particle.color;
      canvas.drawCircle(particle.position, particle.radius, circlePaint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Particle {
  Offset position = Offset(-1, -1);
  double speed = 0.0;
  double angle = 0.0;
  double radius = 0.0;
  double alpha = 0.0;
  Color color = Colors.black;
}
