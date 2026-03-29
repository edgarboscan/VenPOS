class Validators {
  static validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!email) {
      return { isValid: false, message: "El email es requerido" };
    }

    if (!emailRegex.test(email)) {
      return { isValid: false, message: "Email inválido" };
    }

    if (email.length > 100) {
      return { isValid: false, message: "Email demasiado largo" };
    }

    return { isValid: true };
  }

  static validatePassword(password, isLogin = true) {
    if (!password) {
      return { isValid: false, message: "La contraseña es requerida" };
    }

    if (isLogin) {
      if (password.length < 6) {
        return { isValid: false, message: "Mínimo 6 caracteres" };
      }
    } else {
      // Validación más estricta para registro
      if (password.length < 8) {
        return { isValid: false, message: "Mínimo 8 caracteres" };
      }
    }

    return { isValid: true };
  }
}
