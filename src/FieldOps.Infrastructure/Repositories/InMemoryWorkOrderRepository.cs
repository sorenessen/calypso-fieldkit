using FieldOps.Core.Abstractions;
using FieldOps.Core.Models;

namespace FieldOps.Infrastructure.Repositories;

public sealed class InMemoryWorkOrderRepository : IWorkOrderRepository
{
    private readonly List<WorkOrder> _items = new()
    {
        new WorkOrder
        {
            Title = "Replace broken door closer",
            Location = "Building A — 2nd floor",
            Status = WorkOrderStatus.Open,
            Checklist = new() { "Inspect mounting", "Confirm part model", "Install replacement", "Test close speed" },
            Notes = new() { "Reported by front desk." }
        },
        new WorkOrder
        {
            Title = "Generator weekly inspection",
            Location = "Loading bay",
            Status = WorkOrderStatus.InProgress,
            Checklist = new() { "Oil level", "Coolant", "Battery terminals", "Test run 10 min" },
            Notes = new() { "Last inspection flagged minor corrosion." }
        }
    };

    public Task<IReadOnlyList<WorkOrder>> GetAllAsync(CancellationToken ct = default)
        => Task.FromResult<IReadOnlyList<WorkOrder>>(_items
            .OrderByDescending(x => x.CreatedAt)
            .ToList());

    public Task<WorkOrder?> GetByIdAsync(Guid id, CancellationToken ct = default)
        => Task.FromResult(_items.FirstOrDefault(x => x.Id == id));

    public Task UpsertAsync(WorkOrder workOrder, CancellationToken ct = default)
    {
        var existing = _items.FindIndex(x => x.Id == workOrder.Id);
        if (existing >= 0) _items[existing] = workOrder;
        else _items.Add(workOrder);
        return Task.CompletedTask;
    }

    public Task DeleteAsync(Guid id, CancellationToken ct = default)
    {
        _items.RemoveAll(x => x.Id == id);
        return Task.CompletedTask;
    }
}
