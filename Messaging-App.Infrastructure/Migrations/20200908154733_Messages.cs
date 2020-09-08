using System;
using Microsoft.EntityFrameworkCore.Migrations;
using MySql.Data.EntityFrameworkCore.Metadata;

namespace Messaging_App.Infrastructure.Migrations
{
    public partial class Messages : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "UserMessageGroupGroupId",
                table: "Users",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "UserMessageGroupUserId",
                table: "Users",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "UserMessageGroups",
                columns: table => new
                {
                    UserId = table.Column<int>(nullable: false),
                    GroupId = table.Column<int>(nullable: false),
                    IsAdmin = table.Column<bool>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserMessageGroups", x => new { x.UserId, x.GroupId });
                });

            migrationBuilder.CreateTable(
                name: "MessageGroups",
                columns: table => new
                {
                    Id = table.Column<int>(nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    Name = table.Column<string>(nullable: true),
                    IsGroup = table.Column<bool>(nullable: false),
                    UserMessageGroupGroupId = table.Column<int>(nullable: true),
                    UserMessageGroupUserId = table.Column<int>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MessageGroups", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MessageGroups_UserMessageGroups_UserMessageGroupUserId_UserM~",
                        columns: x => new { x.UserMessageGroupUserId, x.UserMessageGroupGroupId },
                        principalTable: "UserMessageGroups",
                        principalColumns: new[] { "UserId", "GroupId" },
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Messages",
                columns: table => new
                {
                    Id = table.Column<int>(nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    SenderId = table.Column<int>(nullable: false),
                    GroupId = table.Column<int>(nullable: false),
                    Content = table.Column<string>(nullable: true),
                    DateSent = table.Column<DateTime>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Messages", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Messages_MessageGroups_GroupId",
                        column: x => x.GroupId,
                        principalTable: "MessageGroups",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Messages_Users_SenderId",
                        column: x => x.SenderId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Users_UserMessageGroupUserId_UserMessageGroupGroupId",
                table: "Users",
                columns: new[] { "UserMessageGroupUserId", "UserMessageGroupGroupId" });

            migrationBuilder.CreateIndex(
                name: "IX_MessageGroups_UserMessageGroupUserId_UserMessageGroupGroupId",
                table: "MessageGroups",
                columns: new[] { "UserMessageGroupUserId", "UserMessageGroupGroupId" });

            migrationBuilder.CreateIndex(
                name: "IX_Messages_GroupId",
                table: "Messages",
                column: "GroupId");

            migrationBuilder.CreateIndex(
                name: "IX_Messages_SenderId",
                table: "Messages",
                column: "SenderId");

            migrationBuilder.AddForeignKey(
                name: "FK_Users_UserMessageGroups_UserMessageGroupUserId_UserMessageGr~",
                table: "Users",
                columns: new[] { "UserMessageGroupUserId", "UserMessageGroupGroupId" },
                principalTable: "UserMessageGroups",
                principalColumns: new[] { "UserId", "GroupId" },
                onDelete: ReferentialAction.Restrict);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Users_UserMessageGroups_UserMessageGroupUserId_UserMessageGr~",
                table: "Users");

            migrationBuilder.DropTable(
                name: "Messages");

            migrationBuilder.DropTable(
                name: "MessageGroups");

            migrationBuilder.DropTable(
                name: "UserMessageGroups");

            migrationBuilder.DropIndex(
                name: "IX_Users_UserMessageGroupUserId_UserMessageGroupGroupId",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "UserMessageGroupGroupId",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "UserMessageGroupUserId",
                table: "Users");
        }
    }
}
