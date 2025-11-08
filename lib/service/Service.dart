abstract class Service<T> {
  Future<bool> update(T object);
  Future<List<T>> getAll();
  Future<T?> findById(int id);
  Future<T> insert(T novo);
  Future<bool> remove(T object);
}