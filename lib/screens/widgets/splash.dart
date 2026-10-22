import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/lang.dart';

class SplashScreen extends StatefulWidget {
	const SplashScreen({super.key, required this.child});

	final Widget child;

	@override
	State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
		with SingleTickerProviderStateMixin {
	late final AnimationController animation = AnimationController(
		vsync: this,
		duration: const Duration(milliseconds: 650),
	);
	Timer? transition;
	bool showingSplash = true;

	@override
	void initState() {
		super.initState();
		animation.forward();
		transition = Timer(const Duration(milliseconds: 900), () {
			if (!mounted) return;
			setState(() => showingSplash = false);
		});
	}

	@override
	void dispose() {
		transition?.cancel();
		animation.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		if (!showingSplash) return widget.child;
		final colors = Theme.of(context).colorScheme;
		return Scaffold(
			body: Center(
				child: FadeTransition(
					opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
					child: ScaleTransition(
						scale: Tween<double>(begin: .88, end: 1).animate(
							CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
						),
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: [
								ClipRRect(
									borderRadius: BorderRadius.circular(32),
									child: Image.asset(
										'assets/icons/logo.jpg',
										width: 128,
										height: 128,
										fit: BoxFit.cover,
									),
								),
								const SizedBox(height: 20),
								Text(
									'Whatsapp Direct',
									style: Theme.of(context).textTheme.headlineSmall?.copyWith(
										color: colors.primary,
										fontWeight: FontWeight.w700,
									),
								),
								const SizedBox(height: 6),
								Text(
									t('tagline'),
									textAlign: TextAlign.center,
									style: Theme.of(context).textTheme.bodyMedium,
								),
							],
						),
					),
				),
			),
		);
	}
}