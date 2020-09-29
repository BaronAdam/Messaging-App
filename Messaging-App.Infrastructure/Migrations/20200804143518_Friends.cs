using Microsoft.EntityFrameworkCore.Migrations;

namespace Messaging_App.Infrastructure.Migrations
{
    public partial class Friends : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                "Name",
                "Users",
                nullable: true);

            migrationBuilder.CreateTable(
                "Contacts",
                table => new
                {
                    UserId = table.Column<int>(nullable: false),
                    ContactId = table.Column<int>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Contacts", x => new {x.UserId, x.ContactId});
                    table.ForeignKey(
                        "FK_Contacts_Users_ContactId",
                        x => x.ContactId,
                        "Users",
                        "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        "FK_Contacts_Users_UserId",
                        x => x.UserId,
                        "Users",
                        "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                "IX_Contacts_ContactId",
                "Contacts",
                "ContactId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                "Contacts");

            migrationBuilder.DropColumn(
                "Name",
                "Users");
        }
    }
}