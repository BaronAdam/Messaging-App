namespace Messaging_App.Infrastructure.Parameters
{
    public class UserParameters
    {
        private const int MaxPageSize = 50;
        
        public int PageNumber { get; set; } = 1;
        private int _pageSize = 10;

        public int PageSize
        {
            get => _pageSize;
            set => _pageSize = value > MaxPageSize ? MaxPageSize : value;
        }

        public int UserId { get; set; }
        public bool Contacts { get; set; } = false;
        public bool InContacts { get; set; } = false;
    }
}