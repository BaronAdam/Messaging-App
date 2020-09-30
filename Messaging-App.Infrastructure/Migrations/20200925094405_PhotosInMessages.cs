using Microsoft.EntityFrameworkCore.Migrations;

namespace Messaging_App.Infrastructure.Migrations
{
    public partial class PhotosInMessages : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                "IsPhoto",
                "Messages",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                "PublicId",
                "Messages",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                "Url",
                "Messages",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                "IsPhoto",
                "Messages");

            migrationBuilder.DropColumn(
                "PublicId",
                "Messages");

            migrationBuilder.DropColumn(
                "Url",
                "Messages");
        }
    }
}