import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api/dio_service.dart';
import '../features/recipes/data/http_recipe_repository.dart';

final dioServiceProvider = Provider<DioService>((ref) => DioService(ref));

final recipeRepositoryProvider = Provider<HttpRecipeRepository>(
  (ref) => HttpRecipeRepository(
    api: ref.read(
      dioServiceProvider,
    ),
  ),
);

final onBoardingPageProvider = StateProvider<int>((ref) => 0);

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});


/* final authRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
  final auth = FirebaseAuthRepository(FirebaseAuth.instance);
  return auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(ref: ref, firebaseAuthRepository: authRepository);
}); */