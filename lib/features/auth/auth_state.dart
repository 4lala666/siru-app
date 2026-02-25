class AuthUiState {
  const AuthUiState({
    this.isLoading = false,
  });

  final bool isLoading;

  AuthUiState copyWith({
    bool? isLoading,
  }) {
    return AuthUiState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
