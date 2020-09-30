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
                "UserMessageGroupGroupId",
                "Users",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                "UserMessageGroupUserId",
                "Users",
                nullable: true);

            migrationBuilder.CreateTable(
                "UserMessageGroups",
                table => new
                {
                    UserId = table.Column<int>(nullable: false),
                    GroupId = table.Column<int>(nullable: false),
                    IsAdmin = table.Column<bool>(nullable: false)
                },
                constraints: table => { table.PrimaryKey("PK_UserMessageGroups", x => new {x.UserId, x.GroupId}); });

            migrationBuilder.CreateTable(
                "MessageGroups",
                table => new
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
                        "FK_MessageGroups_UserMessageGroups_UserMessageGroupUserId_UserM~",
                        x => new {x.UserMessageGroupUserId, x.UserMessageGroupGroupId},
                        "UserMessageGroups",
                        new[] {"UserId", "GroupId"},
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                "Messages",
                table => new
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
                        "FK_Messages_MessageGroups_GroupId",
                        x => x.GroupId,
                        "MessageGroups",
                        "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        "FK_Messages_Users_SenderId",
                        x => x.SenderId,
                        "Users",
                        "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                "IX_Users_UserMessageGroupUserId_UserMessageGroupGroupId",
                "Users",
                new[] {"UserMessageGroupUserId", "UserMessageGroupGroupId"});

            migrationBuilder.CreateIndex(
                "IX_MessageGroups_UserMessageGroupUserId_UserMessageGroupGroupId",
                "MessageGroups",
                new[] {"UserMessageGroupUserId", "UserMessageGroupGroupId"});

            migrationBuilder.CreateIndex(
                "IX_Messages_GroupId",
                "Messages",
                "GroupId");

            migrationBuilder.CreateIndex(
                "IX_Messages_SenderId",
                "Messages",
                "SenderId");

            migrationBuilder.AddForeignKey(
                "FK_Users_UserMessageGroups_UserMessageGroupUserId_UserMessageGr~",
                "Users",
                new[] {"UserMessageGroupUserId", "UserMessageGroupGroupId"},
                "UserMessageGroups",
                principalColumns: new[] {"UserId", "GroupId"},
                onDelete: ReferentialAction.Restrict);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                "FK_Users_UserMessageGroups_UserMessageGroupUserId_UserMessageGr~",
                "Users");

            migrationBuilder.DropTable(
                "Messages");

            migrationBuilder.DropTable(
                "MessageGroups");

            migrationBuilder.DropTable(
                "UserMessageGroups");

            migrationBuilder.DropIndex(
                "IX_Users_UserMessageGroupUserId_UserMessageGroupGroupId",
                "Users");

            migrationBuilder.DropColumn(
                "UserMessageGroupGroupId",
                "Users");

            migrationBuilder.DropColumn(
                "UserMessageGroupUserId",
                "Users");
        }
    }
}