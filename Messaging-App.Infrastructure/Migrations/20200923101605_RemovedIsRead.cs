using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Messaging_App.Infrastructure.Migrations
{
    public partial class RemovedIsRead : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                "DateRead",
                "Messages");

            migrationBuilder.DropColumn(
                "IsRead",
                "Messages");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                "DateRead",
                "Messages",
                "datetime",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<short>(
                "IsRead",
                "Messages",
                "bit",
                nullable: false,
                defaultValue: (short) 0);
        }
    }
}