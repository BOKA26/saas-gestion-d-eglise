export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.1"
  }
  public: {
    Tables: {
      activity_logs: {
        Row: {
          action: string
          church_id: string
          created_at: string
          details: Json | null
          id: string
          user_id: string | null
        }
        Insert: {
          action: string
          church_id: string
          created_at?: string
          details?: Json | null
          id?: string
          user_id?: string | null
        }
        Update: {
          action?: string
          church_id?: string
          created_at?: string
          details?: Json | null
          id?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "activity_logs_church_id_fkey"
            columns: ["church_id"]
            isOneToOne: false
            referencedRelation: "churches"
            referencedColumns: ["id"]
          },
        ]
      }
      announcements: {
        Row: {
          auteur_id: string | null
          church_id: string
          contenu: string
          created_at: string
          date_evenement: string | null
          est_active: boolean | null
          id: string
          image_url: string | null
          titre: string
          type: string | null
          updated_at: string
        }
        Insert: {
          auteur_id?: string | null
          church_id: string
          contenu: string
          created_at?: string
          date_evenement?: string | null
          est_active?: boolean | null
          id?: string
          image_url?: string | null
          titre: string
          type?: string | null
          updated_at?: string
        }
        Update: {
          auteur_id?: string | null
          church_id?: string
          contenu?: string
          created_at?: string
          date_evenement?: string | null
          est_active?: boolean | null
          id?: string
          image_url?: string | null
          titre?: string
          type?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "announcements_church_id_fkey"
            columns: ["church_id"]
            isOneToOne: false
            referencedRelation: "churches"
            referencedColumns: ["id"]
          },
        ]
      }
      churches: {
        Row: {
          adresse: string | null
          code_eglise: string | null
          contact: string | null
          couverture_url: string | null
          created_at: string
          denomination: string | null
          description: string | null
          email: string | null
          facebook: string | null
          id: string
          logo_url: string | null
          nom: string
          pasteur_principal: string | null
          pays: string | null
          site_web: string | null
          telephone: string | null
          updated_at: string
          verset_clef: string | null
          ville: string | null
          whatsapp: string | null
        }
        Insert: {
          adresse?: string | null
          code_eglise?: string | null
          contact?: string | null
          couverture_url?: string | null
          created_at?: string
          denomination?: string | null
          description?: string | null
          email?: string | null
          facebook?: string | null
          id?: string
          logo_url?: string | null
          nom: string
          pasteur_principal?: string | null
          pays?: string | null
          site_web?: string | null
          telephone?: string | null
          updated_at?: string
          verset_clef?: string | null
          ville?: string | null
          whatsapp?: string | null
        }
        Update: {
          adresse?: string | null
          code_eglise?: string | null
          contact?: string | null
          couverture_url?: string | null
          created_at?: string
          denomination?: string | null
          description?: string | null
          email?: string | null
          facebook?: string | null
          id?: string
          logo_url?: string | null
          nom?: string
          pasteur_principal?: string | null
          pays?: string | null
          site_web?: string | null
          telephone?: string | null
          updated_at?: string
          verset_clef?: string | null
          ville?: string | null
          whatsapp?: string | null
        }
        Relationships: []
      }
      donations: {
        Row: {
          church_id: string
          created_at: string
          date_don: string
          id: string
          member_id: string | null
          mode_paiement: string | null
          montant: number
          notes: string | null
          reference: string | null
          statut: string | null
          type: string | null
          type_don: string | null
          user_id: string | null
        }
        Insert: {
          church_id: string
          created_at?: string
          date_don?: string
          id?: string
          member_id?: string | null
          mode_paiement?: string | null
          montant: number
          notes?: string | null
          reference?: string | null
          statut?: string | null
          type?: string | null
          type_don?: string | null
          user_id?: string | null
        }
        Update: {
          church_id?: string
          created_at?: string
          date_don?: string
          id?: string
          member_id?: string | null
          mode_paiement?: string | null
          montant?: number
          notes?: string | null
          reference?: string | null
          statut?: string | null
          type?: string | null
          type_don?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "donations_church_id_fkey"
            columns: ["church_id"]
            isOneToOne: false
            referencedRelation: "churches"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "donations_member_id_fkey"
            columns: ["member_id"]
            isOneToOne: false
            referencedRelation: "members"
            referencedColumns: ["id"]
          },
        ]
      }
      kb_documents: {
        Row: {
          chunk_count: number | null
          church_id: string
          content: string | null
          created_at: string
          id: string
          source_type: string | null
          title: string
          updated_at: string
        }
        Insert: {
          chunk_count?: number | null
          church_id: string
          content?: string | null
          created_at?: string
          id?: string
          source_type?: string | null
          title: string
          updated_at?: string
        }
        Update: {
          chunk_count?: number | null
          church_id?: string
          content?: string | null
          created_at?: string
          id?: string
          source_type?: string | null
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "kb_documents_church_id_fkey"
            columns: ["church_id"]
            isOneToOne: false
            referencedRelation: "churches"
            referencedColumns: ["id"]
          },
        ]
      }
      kb_faq: {
        Row: {
          answer: string
          church_id: string
          created_at: string
          id: string
          question: string
          updated_at: string
        }
        Insert: {
          answer: string
          church_id: string
          created_at?: string
          id?: string
          question: string
          updated_at?: string
        }
        Update: {
          answer?: string
          church_id?: string
          created_at?: string
          id?: string
          question?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "kb_faq_church_id_fkey"
            columns: ["church_id"]
            isOneToOne: false
            referencedRelation: "churches"
            referencedColumns: ["id"]
          },
        ]
      }
      members: {
        Row: {
          adresse: string | null
          church_id: string
          created_at: string
          date_adhesion: string | null
          date_naissance: string | null
          email: string | null
          groupe_departement: string | null
          id: string
          nom: string
          notes: string | null
          photo_url: string | null
          prenom: string | null
          sexe: string | null
          statut: string | null
          telephone: string | null
          updated_at: string
          user_id: string | null
        }
        Insert: {
          adresse?: string | null
          church_id: string
          created_at?: string
          date_adhesion?: string | null
          date_naissance?: string | null
          email?: string | null
          groupe_departement?: string | null
          id?: string
          nom: string
          notes?: string | null
          photo_url?: string | null
          prenom?: string | null
          sexe?: string | null
          statut?: string | null
          telephone?: string | null
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          adresse?: string | null
          church_id?: string
          created_at?: string
          date_adhesion?: string | null
          date_naissance?: string | null
          email?: string | null
          groupe_departement?: string | null
          id?: string
          nom?: string
          notes?: string | null
          photo_url?: string | null
          prenom?: string | null
          sexe?: string | null
          statut?: string | null
          telephone?: string | null
          updated_at?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "members_church_id_fkey"
            columns: ["church_id"]
            isOneToOne: false
            referencedRelation: "churches"
            referencedColumns: ["id"]
          },
        ]
      }
      messages: {
        Row: {
          church_id: string
          content: string | null
          contenu: string
          created_at: string
          id: string
          read: boolean | null
          recipient_role: Database["public"]["Enums"]["app_role"] | null
          recipient_type: string | null
          sender_id: string | null
          subject: string | null
          type: string | null
        }
        Insert: {
          church_id: string
          content?: string | null
          contenu: string
          created_at?: string
          id?: string
          read?: boolean | null
          recipient_role?: Database["public"]["Enums"]["app_role"] | null
          recipient_type?: string | null
          sender_id?: string | null
          subject?: string | null
          type?: string | null
        }
        Update: {
          church_id?: string
          content?: string | null
          contenu?: string
          created_at?: string
          id?: string
          read?: boolean | null
          recipient_role?: Database["public"]["Enums"]["app_role"] | null
          recipient_type?: string | null
          sender_id?: string | null
          subject?: string | null
          type?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "messages_church_id_fkey"
            columns: ["church_id"]
            isOneToOne: false
            referencedRelation: "churches"
            referencedColumns: ["id"]
          },
        ]
      }
      ministries: {
        Row: {
          church_id: string
          created_at: string
          description: string | null
          id: string
          nom: string
          responsable_id: string | null
          updated_at: string
        }
        Insert: {
          church_id: string
          created_at?: string
          description?: string | null
          id?: string
          nom: string
          responsable_id?: string | null
          updated_at?: string
        }
        Update: {
          church_id?: string
          created_at?: string
          description?: string | null
          id?: string
          nom?: string
          responsable_id?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "ministries_church_id_fkey"
            columns: ["church_id"]
            isOneToOne: false
            referencedRelation: "churches"
            referencedColumns: ["id"]
          },
        ]
      }
      ministry_missions: {
        Row: {
          created_at: string
          date_debut: string | null
          date_fin: string | null
          description: string | null
          id: string
          ministry_id: string
          statut: string | null
          titre: string
        }
        Insert: {
          created_at?: string
          date_debut?: string | null
          date_fin?: string | null
          description?: string | null
          id?: string
          ministry_id: string
          statut?: string | null
          titre: string
        }
        Update: {
          created_at?: string
          date_debut?: string | null
          date_fin?: string | null
          description?: string | null
          id?: string
          ministry_id?: string
          statut?: string | null
          titre?: string
        }
        Relationships: [
          {
            foreignKeyName: "ministry_missions_ministry_id_fkey"
            columns: ["ministry_id"]
            isOneToOne: false
            referencedRelation: "ministries"
            referencedColumns: ["id"]
          },
        ]
      }
      notifications: {
        Row: {
          church_id: string | null
          content: string | null
          created_at: string
          est_lue: boolean | null
          id: string
          message: string | null
          read: boolean | null
          title: string | null
          titre: string
          type: string | null
          user_id: string
        }
        Insert: {
          church_id?: string | null
          content?: string | null
          created_at?: string
          est_lue?: boolean | null
          id?: string
          message?: string | null
          read?: boolean | null
          title?: string | null
          titre: string
          type?: string | null
          user_id: string
        }
        Update: {
          church_id?: string | null
          content?: string | null
          created_at?: string
          est_lue?: boolean | null
          id?: string
          message?: string | null
          read?: boolean | null
          title?: string | null
          titre?: string
          type?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "notifications_church_id_fkey"
            columns: ["church_id"]
            isOneToOne: false
            referencedRelation: "churches"
            referencedColumns: ["id"]
          },
        ]
      }
      prayer_requests: {
        Row: {
          answered_at: string | null
          church_id: string
          created_at: string
          date_demande: string | null
          description: string | null
          est_anonyme: boolean | null
          id: string
          membre_id: string | null
          nombre_prieres: number | null
          reponse: string | null
          statut: string | null
          sujet: string
          texte: string | null
          updated_at: string
          user_id: string | null
        }
        Insert: {
          answered_at?: string | null
          church_id: string
          created_at?: string
          date_demande?: string | null
          description?: string | null
          est_anonyme?: boolean | null
          id?: string
          membre_id?: string | null
          nombre_prieres?: number | null
          reponse?: string | null
          statut?: string | null
          sujet: string
          texte?: string | null
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          answered_at?: string | null
          church_id?: string
          created_at?: string
          date_demande?: string | null
          description?: string | null
          est_anonyme?: boolean | null
          id?: string
          membre_id?: string | null
          nombre_prieres?: number | null
          reponse?: string | null
          statut?: string | null
          sujet?: string
          texte?: string | null
          updated_at?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "prayer_requests_church_id_fkey"
            columns: ["church_id"]
            isOneToOne: false
            referencedRelation: "churches"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "prayer_requests_membre_id_fkey"
            columns: ["membre_id"]
            isOneToOne: false
            referencedRelation: "members"
            referencedColumns: ["id"]
          },
        ]
      }
      spiritual_resources: {
        Row: {
          auteur: string | null
          church_id: string
          contenu: string | null
          created_at: string
          est_public: boolean | null
          id: string
          titre: string
          type: string | null
          updated_at: string
          url_media: string | null
        }
        Insert: {
          auteur?: string | null
          church_id: string
          contenu?: string | null
          created_at?: string
          est_public?: boolean | null
          id?: string
          titre: string
          type?: string | null
          updated_at?: string
          url_media?: string | null
        }
        Update: {
          auteur?: string | null
          church_id?: string
          contenu?: string | null
          created_at?: string
          est_public?: boolean | null
          id?: string
          titre?: string
          type?: string | null
          updated_at?: string
          url_media?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "spiritual_resources_church_id_fkey"
            columns: ["church_id"]
            isOneToOne: false
            referencedRelation: "churches"
            referencedColumns: ["id"]
          },
        ]
      }
      user_roles: {
        Row: {
          church_id: string
          created_at: string
          full_name: string | null
          id: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Insert: {
          church_id: string
          created_at?: string
          full_name?: string | null
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Update: {
          church_id?: string
          created_at?: string
          full_name?: string | null
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_roles_church_id_fkey"
            columns: ["church_id"]
            isOneToOne: false
            referencedRelation: "churches"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      generate_church_code: { Args: never; Returns: string }
      has_role: {
        Args: {
          _role: Database["public"]["Enums"]["app_role"]
          _user_id: string
        }
        Returns: boolean
      }
    }
    Enums: {
      app_role: "admin" | "operateur" | "fidele"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      app_role: ["admin", "operateur", "fidele"],
    },
  },
} as const
