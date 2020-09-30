using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Messaging_App.Infrastructure.Migrations
{
    public partial class UpdatedMessages : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                "DateRead",
                "Messages",
                nullable: true,
                defaultValue: null);

            migrationBuilder.AddColumn<bool>(
                "IsRead",
                "Messages",
                nullable: false,
                defaultValue: false);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                "DateRead",
                "Messages");

            migrationBuilder.DropColumn(
                "IsRead",
                "Messages");
        }
    }
}