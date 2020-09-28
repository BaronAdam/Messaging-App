using Microsoft.EntityFrameworkCore.Migrations;

namespace Messaging_App.Infrastructure.Migrations
{
    public partial class PhotosInMessages : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsPhoto",
                table: "Messages",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "PublicId",
                table: "Messages",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Url",
                table: "Messages",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsPhoto",
                table: "Messages");

            migrationBuilder.DropColumn(
                name: "PublicId",
                table: "Messages");

            migrationBuilder.DropColumn(
                name: "Url",
                table: "Messages");
        }
    }
}
