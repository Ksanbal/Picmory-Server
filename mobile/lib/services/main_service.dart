class MainService {
  // Singleton instance
  static final MainService _singleton = MainService._internal();

  // Factory method to return the same instance
  factory MainService() {
    return _singleton;
  }

  // Named constructor
  MainService._internal();

  // Your methods and variables here
}
