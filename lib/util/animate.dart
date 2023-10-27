// import 'package:flutter/material.dart';
//
//
//
// class DelayedFadeIn extends StatelessWidget {
//   const DelayedFadeIn({
//     required this.child,
//     required this.delay,
//     this.duration,
//     super.key,
//   });
//
//   final Widget child;
//   final Duration delay;
//   final Duration? duration;
//
//   @override
//   Widget build(BuildContext context) {
//     return PlayAnimation<double>(
//       tween: Tween(begin: 0.0, end: 1.0), // define tween
//       duration: duration ?? fast, // de
//       delay: delay,
//       builder: (context, child, value) {
//         return Opacity(
//           opacity: value,
//           child: child,
//         );
//       },
//       child: child,
//     );
//   }
// }
//
// class FadeIn extends StatelessWidget {
//   const FadeIn({
//     required this.child,
//     super.key,
//   });
//
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: slow,
//       curve: Curves.easeOutQuint,
//       builder: (context, value, child) {
//         return Opacity(
//           opacity: value,
//           child: child,
//         );
//       },
//       child: child,
//     );
//   }
// }
//
// class ZoomFade extends StatelessWidget {
//   const ZoomFade({
//     required this.child,
//     super.key,
//   });
//
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return FadeIn(
//       child: ZoomIn(
//         child: child,
//       ),
//     );
//   }
// }
//
// class ZoomIn extends StatelessWidget {
//   const ZoomIn({
//     required this.child,
//     super.key,
//   });
//
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.6, end: 1.0),
//       duration: slow,
//       curve: Curves.easeOutCubic,
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: value,
//           child: child,
//         );
//       },
//       child: child,
//     );
//   }
// }
//
// class SlideFromLeft extends StatelessWidget {
//   const SlideFromLeft({
//     required this.child,
//     super.key,
//   });
//
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 1.0, end: 0.0),
//       duration: slow,
//       curve: Curves.easeOutCubic,
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(value * 20 * -1, 0),
//           child: child,
//         );
//       },
//       child: child,
//     );
//   }
// }
//
// class ZoomFromCorner extends StatelessWidget {
//   const ZoomFromCorner({Key? key, required this.child, this.rate})
//       : super(key: key);
//   final Widget child;
//   final double? rate;
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.topCenter,
//       child: Container(
//         constraints: const BoxConstraints(maxWidth: 900),
//         child: Padding(
//           padding: const EdgeInsets.only(right: 24.0, top: 40),
//           child: TweenAnimationBuilder<double>(
//             tween: Tween(begin: 0.0, end: 1.0),
//             duration: midSpeed,
//             curve: Curves.decelerate,
//             builder: (context, value, child) {
//               return Transform.scale(
//                 alignment: Alignment.topRight,
//                 scale: value,
//                 child: child,
//               );
//             },
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class SlideFromBelow extends StatelessWidget {
//   const SlideFromBelow({
//     required this.child,
//     this.rate,
//     super.key,
//   });
//
//   final Widget child;
//   final double? rate;
//
//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 1.0, end: 0.0),
//       duration: fast,
//       curve: Curves.easeOutQuad,
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(0, value * (rate ?? 20)),
//           child: child,
//         );
//       },
//       child: child,
//     );
//   }
// }
