﻿// <auto-generated />
using System;
using Messaging_App.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace Messaging_App.Infrastructure.Migrations
{
    [DbContext(typeof(AppDbContext))]
    [Migration("20200925094405_PhotosInMessages")]
    partial class PhotosInMessages
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "3.1.6")
                .HasAnnotation("Relational:MaxIdentifierLength", 64);

            modelBuilder.Entity("Messaging_App.Domain.Models.Contact", b =>
                {
                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.Property<int>("ContactId")
                        .HasColumnType("int");

                    b.HasKey("UserId", "ContactId");

                    b.HasIndex("ContactId");

                    b.ToTable("Contacts");
                });

            modelBuilder.Entity("Messaging_App.Domain.Models.Message", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<string>("Content")
                        .HasColumnType("text");

                    b.Property<DateTime>("DateSent")
                        .HasColumnType("datetime");

                    b.Property<int>("GroupId")
                        .HasColumnType("int");

                    b.Property<bool>("IsPhoto")
                        .HasColumnType("bit");

                    b.Property<string>("PublicId")
                        .HasColumnType("text");

                    b.Property<int>("SenderId")
                        .HasColumnType("int");

                    b.Property<string>("Url")
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.HasIndex("GroupId");

                    b.HasIndex("SenderId");

                    b.ToTable("Messages");
                });

            modelBuilder.Entity("Messaging_App.Domain.Models.MessageGroup", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<bool>("IsGroup")
                        .HasColumnType("bit");

                    b.Property<string>("Name")
                        .HasColumnType("text");

                    b.Property<int?>("UserMessageGroupGroupId")
                        .HasColumnType("int");

                    b.Property<int?>("UserMessageGroupUserId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("UserMessageGroupUserId", "UserMessageGroupGroupId");

                    b.ToTable("MessageGroups");
                });

            modelBuilder.Entity("Messaging_App.Domain.Models.User", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<string>("Email")
                        .HasColumnType("text");

                    b.Property<string>("Name")
                        .HasColumnType("text");

                    b.Property<byte[]>("PasswordHash")
                        .HasColumnType("varbinary(4000)");

                    b.Property<byte[]>("PasswordSalt")
                        .HasColumnType("varbinary(4000)");

                    b.Property<int?>("UserMessageGroupGroupId")
                        .HasColumnType("int");

                    b.Property<int?>("UserMessageGroupUserId")
                        .HasColumnType("int");

                    b.Property<string>("Username")
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.HasIndex("UserMessageGroupUserId", "UserMessageGroupGroupId");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("Messaging_App.Domain.Models.UserMessageGroup", b =>
                {
                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.Property<int>("GroupId")
                        .HasColumnType("int");

                    b.Property<bool>("IsAdmin")
                        .HasColumnType("bit");

                    b.HasKey("UserId", "GroupId");

                    b.ToTable("UserMessageGroups");
                });

            modelBuilder.Entity("Messaging_App.Domain.Models.Contact", b =>
                {
                    b.HasOne("Messaging_App.Domain.Models.User", "Friend")
                        .WithMany("Contacts1")
                        .HasForeignKey("ContactId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("Messaging_App.Domain.Models.User", "User")
                        .WithMany("Contacts2")
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();
                });

            modelBuilder.Entity("Messaging_App.Domain.Models.Message", b =>
                {
                    b.HasOne("Messaging_App.Domain.Models.MessageGroup", "Group")
                        .WithMany("Messages")
                        .HasForeignKey("GroupId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("Messaging_App.Domain.Models.User", "Sender")
                        .WithMany("Messages")
                        .HasForeignKey("SenderId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("Messaging_App.Domain.Models.MessageGroup", b =>
                {
                    b.HasOne("Messaging_App.Domain.Models.UserMessageGroup", null)
                        .WithMany("MessageGroups")
                        .HasForeignKey("UserMessageGroupUserId", "UserMessageGroupGroupId");
                });

            modelBuilder.Entity("Messaging_App.Domain.Models.User", b =>
                {
                    b.HasOne("Messaging_App.Domain.Models.UserMessageGroup", null)
                        .WithMany("Users")
                        .HasForeignKey("UserMessageGroupUserId", "UserMessageGroupGroupId");
                });
#pragma warning restore 612, 618
        }
    }
}