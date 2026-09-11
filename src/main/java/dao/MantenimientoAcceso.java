package dao;

import java.util.List;

public interface MantenimientoAcceso<T> {
    boolean insertar(T objeto);
    boolean actualizar(T objeto);
    List<T> listarTodos();
    T obtener(Object id);
}