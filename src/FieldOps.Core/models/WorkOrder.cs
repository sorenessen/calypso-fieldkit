namespace FieldOps.Core.Models;

public enum WorkOrderStatus
{
    Open = 0,
    InProgress = 1,
    Done = 2,
}

public sealed class WorkOrder
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string Title { get; set; } = "";
    public string? Location { get; set; }
    public WorkOrderStatus Status { get; set; } = WorkOrderStatus.Open;
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public List<string> Checklist { get; set; } = new();
    public List<string> Notes { get; set; } = new();
}
