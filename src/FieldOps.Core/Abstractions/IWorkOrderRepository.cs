using FieldOps.Core.Models;

namespace FieldOps.Core.Abstractions;

public interface IWorkOrderRepository
{
    Task<IReadOnlyList<WorkOrder>> GetAllAsync(CancellationToken ct = default);
    Task<WorkOrder?> GetByIdAsync(Guid id, CancellationToken ct = default);
    Task UpsertAsync(WorkOrder workOrder, CancellationToken ct = default);
    Task DeleteAsync(Guid id, CancellationToken ct = default);
}
