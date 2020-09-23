using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Messaging_App.Infrastructure.Migrations
{
    public partial class RemovedIsRead : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DateRead",
                table: "Messages");

            migrationBuilder.DropColumn(
                name: "IsRead",
                table: "Messages");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "DateRead",
                table: "Messages",
                type: "datetime",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<short>(
                name: "IsRead",
                table: "Messages",
                type: "bit",
                nullable: false,
                defaultValue: (short)0);
        }
    }
}
